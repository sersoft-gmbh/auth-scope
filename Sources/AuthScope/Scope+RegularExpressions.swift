import RegexBuilder

extension Scope {
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    private struct AccessRangeMatcher: CustomConsumingRegexComponent {
        typealias RegexOutput = Scope

        enum MatchKind: Sendable, Hashable {
            case exact, all, any
        }

        let expected: Scope
        let matchKind: MatchKind

        func consuming(_ input: String, 
                       startingAt index: String.Index,
                       in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: RegexOutput)? {
            let string = input[bounds][index...]
            let isExact = matchKind == .exact

            var detectedScope = Scope()
            var currentStart = string.startIndex
            var currentEnd = string.firstIndex(of: Scope.stringSeparator) ?? string.endIndex
            repeat {
                if let accessRange = AccessRange(string: string[currentStart..<currentEnd]) {
                    detectedScope.insert(accessRange)
                } else if isExact {
                    return nil
                }
                guard currentEnd < string.endIndex else { break }
                currentStart = string.index(after: currentEnd)
                currentEnd = string[currentStart...].firstIndex(of: Scope.stringSeparator) ?? string.endIndex
            } while true

            let didMatch = switch matchKind {
            case .exact: detectedScope == expected
            case .all: detectedScope.isSuperset(of: expected)
            case .any: !detectedScope.isDisjoint(with: expected)
            }
            guard didMatch else { return nil }
            return (currentEnd, detectedScope)
        }
    }

    /// Returns a regular expression string that matches a string that has exactly the access ranges in self (not more, not less).
    /// - Note: The order of the access ranges in the string is irrelevant.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public var exactMatchRegex: Regex<Substring> {
        guard !accessRanges.isEmpty else { return /^$/ }
        return Regex {
            /^/
            AccessRangeMatcher(expected: self, matchKind: .exact)
            /$/
        }
    }

    /// Returns a regular expression pattern that matches a string that has at least the access ranges in self (but can have more).
    /// - Note: The order of the access ranges in the string is irrelevant.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public var containsAllRegex: Regex<Substring> {
        guard !accessRanges.isEmpty else { return /^.*$/ }
        return Regex {
            /^/
            AccessRangeMatcher(expected: self, matchKind: .all)
            /$/
        }
    }

    /// Returns a regular expression pattern that matches a string that has at least one of access ranges in self (but not all).
    /// - Note: The order of the access ranges in the string is irrelevant.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public var containsAnyRegex: Regex<Substring> {
        guard !accessRanges.isEmpty else { return /^.*$/ }
        return Regex {
            /^/
            AccessRangeMatcher(expected: self, matchKind: .any)
            /$/
        }
    }

    @inline(__always)
    private var startOfAccessRangePattern: String {
        "(?:^|\(Scope.stringSeparator))"
    }

    @inline(__always)
    private var endOfAccessRangePattern: String {
        "(?:\(Scope.stringSeparator)|$)"
    }

    /// Returns a regular expression pattern that matches a string that has exactly the access ranges in self (not more, not less).
    /// - Note: The order of the access ranges in the string is irrelevant.
    public var exactMatchRegexPattern: String {
        guard !accessRanges.isEmpty else { return "^$" }
        let lookAheads = accessRanges.lazy
            .map { ($0.rawValue, accessRanges.subtracting([$0]).lazy.map(\.rawValue).joined(separator: "|")) }
            .map { "(?=(?:^|(?:(?:\($1))\(endOfAccessRangePattern))+)\($0)\(endOfAccessRangePattern))" }
            .joined()
        return "^" + lookAheads + "(?:(?:" + accessRanges.lazy.map(\.rawValue).joined(separator: "|") + ")\(endOfAccessRangePattern))*$"
    }

    /// Returns a regular expression pattern that matches a string that has at least the access ranges in self (but can have more).
    /// - Note: The order of the access ranges in the string is irrelevant.
    public var containsAllRegexPattern: String {
        guard !accessRanges.isEmpty else { return "^.*$" }
        let lookAheads = accessRanges.lazy
            .map(\.rawValue)
            .map { "(?=.*\(startOfAccessRangePattern)\($0)\(endOfAccessRangePattern))" }
            .joined()
        return "^" + lookAheads + ".+$"
    }

    /// Returns a regular expression pattern that matches a string that has at least one of access ranges in self (but not all).
    /// - Note: The order of the access ranges in the string is irrelevant.
    public var containsAnyRegexPattern: String {
        guard !accessRanges.isEmpty else { return "^.*$" }
        return "\(startOfAccessRangePattern)(?:" + accessRanges.lazy.map(\.rawValue).joined(separator: "|") + ")\(endOfAccessRangePattern)"
    }
}
