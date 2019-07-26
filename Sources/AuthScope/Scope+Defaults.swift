extension Scope where AccessRange: CaseIterable {
    /// Returns a scope with all possible access ranges.
    @inlinable
    public static var all: Scope { return Scope(accessRanges: AccessRange.allCases) }
}
