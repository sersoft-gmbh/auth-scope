import Testing
@testable import AuthScope

@Suite
struct ScopeTests {
    @Test
    func scopeInitializerWithAccessRangeSet() {
        let accessRanges: Set<TestAccessRange> = [.a, .b, .c, .d]
        let scope = Scope(accessRanges: accessRanges)
        #expect(scope.accessRanges == accessRanges)
    }

    @Test
    func scopeInitializerWithAccessRangeCollection() {
        let accessRanges: Array<TestAccessRange> = [.a, .b, .c, .d]
        let scope = Scope(accessRanges: accessRanges)
        #expect(scope.accessRanges == Set(accessRanges))
    }

    @Test
    func scopeInitializerWithAccessRangeVariadicList() {
        let scope = Scope<TestAccessRange>(accessRanges: .a, .b, .c, .d)
        #expect(scope.accessRanges == [.a, .b, .c, .d])
    }

    @Test
    func scopeEmptyInitializer() {
        #expect(Scope<TestAccessRange>().accessRanges.isEmpty)
    }

    @Test
    func scopeEquatabilityIsBasedOnAccessRange() {
        let scope1 = Scope<TestAccessRange>(accessRanges: .a, .b, .c, .d)
        let scope2 = Scope<TestAccessRange>(accessRanges: .a, .b, .c, .d)
        let scope3 = Scope<TestAccessRange>(accessRanges: .a, .b, .c)
        #expect((scope1 == scope2) == (scope1.accessRanges == scope2.accessRanges))
        #expect((scope2 == scope3) == (scope2.accessRanges == scope3.accessRanges))
        #expect(scope1 == scope2)
        #expect(scope2 != scope3)
    }

    @Test
    func scopeHashingIsBasedOnAccessRange() {
        let scope = Scope<TestAccessRange>(accessRanges: .a, .b, .c, .d)
        var hasher = Hasher()
        hasher.combine(scope.accessRanges)
        #expect(hasher.finalize() == scope.hashValue)
    }
}
