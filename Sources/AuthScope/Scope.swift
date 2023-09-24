/// A set of access ranges.
public struct Scope<AccessRange: AccessRangeProtocol>: Hashable, Sendable {
    /// The internal access ranges.
    @usableFromInline
    internal var accessRanges: Set<AccessRange>

    /// Creates a new scope with the given ``Swift/Set`` of access ranges.
    /// - Parameter accessRanges: ``Swift/Set`` of access ranges to use in the new scope.
    public init(accessRanges: Set<AccessRange>) {
        self.accessRanges = accessRanges
    }

    /// Creates a new scope with the given collection of access ranges.
    /// - Parameter accessRanges: A collection access ranges to use in the new scope.
    @inlinable
    public init(accessRanges: some Sequence<AccessRange>) {
        self.init(accessRanges: Set(accessRanges))
    }

    /// Creates a new scope with the given list of access ranges.
    /// - Parameter accessRanges: A variadic list of access ranges to use in the new scope.
    @inlinable
    public init(accessRanges: AccessRange...) {
        self.init(accessRanges: accessRanges)
    }

    /// Creates a new, empty scope.
    @inlinable
    public init() { self.init(accessRanges: Set()) }
}
