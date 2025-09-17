extension Scope: Collection {
    public typealias Element = AccessRange

    /// The index type of ``Scope``.
    @frozen
    public struct Index: Sendable, Hashable, Comparable {
        @usableFromInline
        let setIndex: Set<Element>.Index

        @inlinable
        init(setIndex: Set<Element>.Index) {
            self.setIndex = setIndex
        }

        @inlinable
        public static func <(lhs: Self, rhs: Self) -> Bool {
            lhs.setIndex < rhs.setIndex
        }
    }

    @inlinable
    public var isEmpty: Bool { accessRanges.isEmpty }

    @inlinable
    public var startIndex: Index { .init(setIndex: accessRanges.startIndex) }

    @inlinable
    public var endIndex: Index { .init(setIndex: accessRanges.endIndex) }

    @inlinable
    public subscript(position: Index) -> Element { accessRanges[position.setIndex] }

    @inlinable
    public func index(after i: Index) -> Index { .init(setIndex: accessRanges.index(after: i.setIndex)) }

    /// Filters the scope by calling `isIncluded` with each contained access range and only adding the ones for which it returns true to the result.
    /// - Parameter isIncluded: The closure called for each access range. Should return `true` if the access range should be included in the result, `false` otherwise.
    /// - Throws: Any error thrown by `isIncluded`.
    /// - Returns: A filtered scope which only contains the access ranges for which `isIncluded` returned `true`.
    @inlinable
    public func filter<F: Error>(_ isIncluded: (AccessRange) throws(F) -> Bool) throws(F) -> Scope {
        // FIXME: Change once Swift supports typed throws in Set.filter.
        do {
            return try Scope(accessRanges: accessRanges.filter(isIncluded))
        } catch {
            throw error as! F
        }
    }
}
