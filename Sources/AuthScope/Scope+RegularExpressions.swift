extension Scope {
    @inline(__always)
    private var accessRangesRegExGroup: String {
        "(?:" + accessRanges.lazy.map(\.rawValue).joined(separator: "|") + ")"
    }

    @inline(__always)
    private var accessRangesAsRegExGroups: Repeated<String> {
        repeatElement(accessRangesRegExGroup, count: accessRanges.count)
    }

    /// Returns a regular expression string that matches a string that has exactly the access ranges in self (not more, not less).
    /// - Note: The order of the access ranges in the string is irrelevant.
    public var exactMatchRegExp: String {
        "^" + accessRangesAsRegExGroups.joined(separator: String(Scope.stringSeparator)) + "$"
    }

    /// Returns a regular expression string that matches a string that has at least the access ranges in self (but can have more).
    /// - Note: The order of the access ranges in the string is irrelevant.
    public var containsAllRegExp: String {
        let anyScopeRegEx = "(?:[^ ]+ )*"
        return "^" + anyScopeRegEx
            + accessRangesAsRegExGroups.joined(separator: String(Scope.stringSeparator) + anyScopeRegEx)
            + "(?: (?:[^ ]+(?: |$))+|$)"
    }

    /// Returns a regular expression string that matches a string that has at least one of access ranges in self (but not all).
    /// - Note: The order of the access ranges in the string is irrelevant.
    public var containsAnyRegExp: String {
        "(?:^| )" + accessRangesRegExGroup + "(?: |$)"
    }
}
