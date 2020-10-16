extension Scope: Collection {
    /// See: `Collection.Element`
    public typealias Element = AccessRange

    /// The index type of `Scope`.
    @frozen
    public struct Index: Comparable {
        @usableFromInline
        let setIndex: Set<Element>.Index

        @usableFromInline
        init(setIndex: Set<Element>.Index) {
            self.setIndex = setIndex
        }

        /// See `Comparable.<`
        @inlinable
        public static func <(lhs: Self, rhs: Self) -> Bool {
            lhs.setIndex < rhs.setIndex
        }
    }

    /// See `Collection.isEmpty`
    @inlinable
    public var isEmpty: Bool { accessRanges.isEmpty }

    /// See `Collection.startIndex`
    @inlinable
    public var startIndex: Index { .init(setIndex: accessRanges.startIndex) }

    /// See `Collection.endIndex`
    @inlinable
    public var endIndex: Index { .init(setIndex: accessRanges.endIndex) }

    /// See `Collection.subscript(position:)`
    @inlinable
    public subscript(position: Index) -> Element { accessRanges[position.setIndex] }

    /// See `Collection.index(after:)`
    @inlinable
    public func index(after i: Index) -> Index { .init(setIndex: accessRanges.index(after: i.setIndex)) }

    /// Filters the scope by calling `isIncluded` with each contained access range and only adding the ones for which it returns true to the result.
    /// - Parameter isIncluded: The closure called for each access range. Should return `true` if the access range should be included in the result, `false` otherwise.
    /// - Throws: Any error thrown by `isIncluded`.
    /// - Returns: A filtered scope which only contains the access ranges for which `isIncluded` returned `true`.
    @inlinable
    public func filter(_ isIncluded: (AccessRange) throws -> Bool) rethrows -> Scope {
        try Scope(accessRanges: accessRanges.filter(isIncluded))
    }
}
