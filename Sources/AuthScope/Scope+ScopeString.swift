extension Scope {
    /// The separator used to seperate access ranges in scope strings.
    @usableFromInline
    internal static var stringSeparator: Character { "\u{20}" } // space

    /// A string containing all access ranges in self seperated by space.
    public var scopeString: String {
        accessRanges.lazy.map(\.rawValue).joined(separator: String(Scope.stringSeparator))
    }

    /// Creates a new scope from a given scope string. Throws an error if the string contains invalid access ranges.
    ///
    /// - Parameter scopeString: The scope string (e.g. created by `scopeString` of an existing scope) to parse.
    /// - Throws: An error if at least one of the access ranges in the scope string is invalid.
    /// - SeeAlso: ``AccessRangeProtocol/init(validating:)``
    public init(scopeString: some StringProtocol) throws {
        try self.init(accessRanges: scopeString.split(separator: Scope.stringSeparator).map(AccessRange.init(validating:)))
    }
}
