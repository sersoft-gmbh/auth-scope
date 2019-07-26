extension Scope: Collection {
    public typealias Element = AccessRange
    public typealias Index = Set<Element>.Index

    @inlinable
    public var isEmpty: Bool { return accessRanges.isEmpty }

    @inlinable
    public var startIndex: Index { return accessRanges.startIndex }

    @inlinable
    public var endIndex: Index { return accessRanges.endIndex }

    @inlinable
    public subscript(position: Index) -> Element { return accessRanges[position] }

    @inlinable
    public func index(after i: Index) -> Index { return accessRanges.index(after: i) }

    @inlinable
    public func filter(_ isIncluded: (AccessRange) throws -> Bool) rethrows -> Scope {
        return try Scope(accessRanges: accessRanges.filter(isIncluded))
    }
}
