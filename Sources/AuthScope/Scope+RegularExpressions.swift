import RegexBuilder

extension Scope {
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    private struct AccessRangeMatcher<Separator: RegexComponent>: CustomConsumingRegexComponent {
        typealias RegexOutput = AccessRange

        private let separator: Separator
        private let accessRangeRegexes: Array<Regex<(Substring, Substring)>>

        init(separator: Separator, accessRanges: Set<AccessRange>) {
            self.separator = separator
            accessRangeRegexes = accessRanges.map { accessRange in
                Regex {
                    ChoiceOf {
                        /^/
                        separator
                    }
                    Capture(accessRange.rawValue)
                    ChoiceOf {
                        separator
                        /$/
                    }
                }
            }
        }

        func consuming(_ input: String, 
                       startingAt index: String.Index,
                       in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: AccessRange)? {
            let string = input[bounds][index...]
            let accessRange = try accessRangeRegexes.lazy.compactMap {
                do {
                    return try $0.prefixMatch(in: string).map { .success($0) } as Result<Regex.Match, any Error>?
                } catch {
                    return Result.failure(error)
                }
            }.first?.get()
            return try accessRange.flatMap { match in
                try AccessRange(string: match.output.1).map {
                    var upperBound = match.range.upperBound
                    if let separatorMatch = try separator.regex.firstMatch(in: match.output.0.dropFirst($0.rawValue.count)) {
                        upperBound = separatorMatch.range.lowerBound
                    }
                    return (upperBound, $0)
                }
            }
        }
    }

    /// Returns a regular expression string that matches a string that has exactly the access ranges in self (not more, not less).
    /// - Note: The order of the access ranges in the string is irrelevant.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public var exactMatchRegex: Regex<Substring> {
        Regex {
            /^/
            Repeat(count: accessRanges.count) {
                AccessRangeMatcher(separator: Scope.stringSeparator,
                                   accessRanges: accessRanges)
            }
            /$/
        }
    }

    /// Returns a regular expression pattern that matches a string that has at least the access ranges in self (but can have more).
    /// - Note: The order of the access ranges in the string is irrelevant.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public var containsAllRegex: Regex<Substring> {
        let oneOrMoreNonSeparator = OneOrMore(CharacterClass.anyOf(CollectionOfOne(Scope.stringSeparator)).inverted)
        let anyAccessRange = Regex {
            ZeroOrMore {
                oneOrMoreNonSeparator
                Scope.stringSeparator
            }
        }
        return Regex {
            /^/
            anyAccessRange
            Repeat(count: accessRanges.count) {
                AccessRangeMatcher(separator: Regex {
                    Scope.stringSeparator
                    anyAccessRange
                }, accessRanges: accessRanges)
            }
            ChoiceOf {
                Regex {
                    Scope.stringSeparator
                    OneOrMore {
                        oneOrMoreNonSeparator
                        ChoiceOf {
                            Scope.stringSeparator
                            /$/
                        }
                    }
                }
                /$/
            }
        }
    }

    /// Returns a regular expression pattern that matches a string that has at least one of access ranges in self (but not all).
    /// - Note: The order of the access ranges in the string is irrelevant.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public var containsAnyRegex: Regex<Substring> {
        Regex {
            ChoiceOf {
                /^/
                Scope.stringSeparator
            }
            OneOrMore {
                AccessRangeMatcher(separator: Scope.stringSeparator,
                                   accessRanges: accessRanges)
            }
            ChoiceOf {
                Scope.stringSeparator
                /$/
            }
        }
    }

    @inline(__always)
    private var accessRangesRegExGroupString: String {
        "(?:" + accessRanges.lazy.map(\.rawValue).joined(separator: "|") + ")"
    }

    @inline(__always)
    private var accessRangesAsRegExGroupStrings: Repeated<String> {
        repeatElement(accessRangesRegExGroupString, count: accessRanges.count)
    }

    /// Returns a regular expression pattern that matches a string that has exactly the access ranges in self (not more, not less).
    /// - Note: The order of the access ranges in the string is irrelevant.
    public var exactMatchRegexPattern: String {
        "^" + accessRangesAsRegExGroupStrings.joined(separator: String(Scope.stringSeparator)) + "$"
    }

    /// Returns a regular expression pattern that matches a string that has at least the access ranges in self (but can have more).
    /// - Note: The order of the access ranges in the string is irrelevant.
    public var containsAllRegexPattern: String {
        let anyScopeRegEx = "(?:[^ ]+ )*"
        return "^" + anyScopeRegEx
            + accessRangesAsRegExGroupStrings.joined(separator: String(Scope.stringSeparator) + anyScopeRegEx)
            + "(?: (?:[^ ]+(?: |$))+|$)"
    }

    /// Returns a regular expression pattern that matches a string that has at least one of access ranges in self (but not all).
    /// - Note: The order of the access ranges in the string is irrelevant.
    public var containsAnyRegexPattern: String {
        "(?:^| )" + accessRangesRegExGroupString + "(?: |$)"
    }
}
