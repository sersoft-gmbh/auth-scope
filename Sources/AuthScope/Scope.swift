public struct Scope<AccessRange: AccessRangeProtocol>: Hashable {
    /// The internal access ranges.
    @usableFromInline
    internal var accessRanges: Set<AccessRange>

    /// Creates a new scope with the given `Set` of access ranges.
    ///
    /// - Parameter accessRanges: `Set` of access ranges to use in the new scope.
    public init(accessRanges: Set<AccessRange>) {
        self.accessRanges = accessRanges
    }

    /// Creates a new scope with the given collection of access ranges.
    ///
    /// - Parameter accessRanges: A collection access ranges to use in the new scope.
    @inlinable
    public init<C: Collection>(accessRanges: C) where C.Element == AccessRange {
        self.init(accessRanges: Set(accessRanges))
    }

    /// Creates a new scope with the given list of access ranges.
    ///
    /// - Parameter accessRanges: A variadic list of access ranges to use in the new scope.
    @inlinable
    public init(accessRanges: AccessRange...) {
        self.init(accessRanges: accessRanges)
    }

    /// Creates a new, empty scope.
    @inlinable
    public init() { self.init(accessRanges: Set()) }
}
