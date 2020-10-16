extension Scope: SetAlgebra {
    /// See `ExpressibleByArrayLiteral.ArrayLiteralElement`
    public typealias ArrayLiteralElement = Element

    /// See `ExpressibleByArrayLiteral.init(arrayLiteral:)`
    @inlinable
    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(accessRanges: elements)
    }

    /// See `SetAlgebra.union(_:)`
    @inlinable
    public __consuming func union(_ other: __owned Scope) -> Scope {
        Scope(accessRanges: accessRanges.union(other.accessRanges))
    }

    /// See `SetAlgebra.formUnion(_:)`
    @inlinable
    public mutating func formUnion(_ other: __owned Scope) {
        accessRanges.formUnion(other.accessRanges)
    }

    /// See `SetAlgebra.intersection(_:)`
    @inlinable
    public __consuming func intersection(_ other: Scope) -> Scope {
        Scope(accessRanges: accessRanges.intersection(other.accessRanges))
    }

    /// See `SetAlgebra.formIntersection(_:)`
    @inlinable
    public mutating func formIntersection(_ other: Scope) {
        accessRanges.formIntersection(other.accessRanges)
    }

    /// See `SetAlgebra.symmetricDifference(_:)`
    @inlinable
    public __consuming func symmetricDifference(_ other: __owned Scope) -> Scope {
        Scope(accessRanges: accessRanges.symmetricDifference(other.accessRanges))
    }

    /// See `SetAlgebra.formSymmetricDifference(_:)`
    @inlinable
    public mutating func formSymmetricDifference(_ other: __owned Scope) {
        accessRanges.formSymmetricDifference(other.accessRanges)
    }

    /// See `SetAlgebra.insert(_:)`
    @inlinable
    @discardableResult
    public mutating func insert(_ newMember: __owned Element) -> (inserted: Bool, memberAfterInsert: Element) {
        accessRanges.insert(newMember)
    }

    /// See `SetAlgebra.update(with:)`
    @inlinable
    @discardableResult
    public mutating func update(with newMember: __owned Element) -> Element? {
        accessRanges.update(with: newMember)
    }

    /// See `SetAlgebra.remove(_:)`
    @inlinable
    @discardableResult
    public mutating func remove(_ member: Element) -> Element? {
        accessRanges.remove(member)
    }
}
