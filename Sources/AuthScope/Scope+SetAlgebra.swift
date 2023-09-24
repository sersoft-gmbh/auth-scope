extension Scope: SetAlgebra {
    public typealias ArrayLiteralElement = Element

    @inlinable
    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(accessRanges: elements)
    }

    @inlinable
    public __consuming func union(_ other: __owned Scope) -> Scope {
        Scope(accessRanges: accessRanges.union(other.accessRanges))
    }

    @inlinable
    public mutating func formUnion(_ other: __owned Scope) {
        accessRanges.formUnion(other.accessRanges)
    }

    @inlinable
    public __consuming func intersection(_ other: Scope) -> Scope {
        Scope(accessRanges: accessRanges.intersection(other.accessRanges))
    }

    @inlinable
    public mutating func formIntersection(_ other: Scope) {
        accessRanges.formIntersection(other.accessRanges)
    }

    @inlinable
    public __consuming func symmetricDifference(_ other: __owned Scope) -> Scope {
        Scope(accessRanges: accessRanges.symmetricDifference(other.accessRanges))
    }

    @inlinable
    public mutating func formSymmetricDifference(_ other: __owned Scope) {
        accessRanges.formSymmetricDifference(other.accessRanges)
    }

    @inlinable
    @discardableResult
    public mutating func insert(_ newMember: __owned Element) -> (inserted: Bool, memberAfterInsert: Element) {
        accessRanges.insert(newMember)
    }

    @inlinable
    @discardableResult
    public mutating func update(with newMember: __owned Element) -> Element? {
        accessRanges.update(with: newMember)
    }

    @inlinable
    @discardableResult
    public mutating func remove(_ member: Element) -> Element? {
        accessRanges.remove(member)
    }
}
