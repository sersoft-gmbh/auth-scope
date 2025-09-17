import Testing
import AuthScope

@Suite
struct Scope_SetAlgebraTests {
    @Test
    func scopeCreationWithArrayLiteral() {
        #expect([.a, .b, .c] == Scope<TestAccessRange>(accessRanges: [.a, .b, .c] as Set))
    }

    @Test
    func scopeUnion() {
        let scope1: Scope<TestAccessRange> = [.a, .b, .c]
        let scope2: Scope<TestAccessRange> = [.c, .d, .e]
        #expect(scope1.union(scope2) == [.a, .b, .c, .d, .e])
    }

    @Test
    func scopeUnionForming() {
        var scope: Scope<TestAccessRange> = [.a, .b, .c]
        scope.formUnion([.c, .d, .e])
        #expect(scope == [.a, .b, .c, .d, .e])
    }

    @Test
    func scopeIntersection() {
        let scope1: Scope<TestAccessRange> = [.a, .b, .c, .d]
        let scope2: Scope<TestAccessRange> = [.c, .d, .e, .f]
        #expect(scope1.intersection(scope2) == [.c, .d])
    }

    @Test
    func scopeIntersectionForming() {
        var scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        scope.formIntersection([.c, .d, .e, .f])
        #expect(scope == [.c, .d])
    }

    @Test
    func scopeSymmetricDifference() {
        let scope1: Scope<TestAccessRange> = [.a, .b, .c, .d]
        let scope2: Scope<TestAccessRange> = [.c, .d, .e, .f]
        #expect(scope1.symmetricDifference(scope2) == [.a, .b, .e, .f])
    }

    @Test
    func scopeSymmetricDifferenceForming() {
        var scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        scope.formSymmetricDifference([.c, .d, .e, .f])
        #expect(scope == [.a, .b, .e, .f])
    }

    @Test
    func scopeInsertion() {
        var scope: Scope<TestAccessRange> = [.a, .b, .c]

        let result1 = scope.insert(.d)
        #expect(scope == [.a, .b, .c, .d])
        #expect(result1.inserted)
        #expect(result1.memberAfterInsert == .d)

        let result2 = scope.insert(.d)
        #expect(scope == [.a, .b, .c, .d])
        #expect(!result2.inserted)
        #expect(result2.memberAfterInsert == .d)
    }
    
    @Test
    func scopeUpdate() {
        var scope: Scope<TestAccessRange> = [.a, .b, .c]

        let result1 = scope.update(with: .d)
        #expect(scope == [.a, .b, .c, .d])
        #expect(result1 == nil)

        let result2 = scope.update(with: .d)
        #expect(scope == [.a, .b, .c, .d])
        #expect(result2 != nil)
        #expect(result2 == .d)
    }

    @Test
    func scopeRemoval() {
        var scope: Scope<TestAccessRange> = [.a, .b, .c, .d]

        let result1 = scope.remove(.d)
        #expect(scope == [.a, .b, .c])
        #expect(result1 != nil)
        #expect(result1 == .d)

        let result2 = scope.remove(.d)
        #expect(scope == [.a, .b, .c])
        #expect(result2 == nil)
    }
}
