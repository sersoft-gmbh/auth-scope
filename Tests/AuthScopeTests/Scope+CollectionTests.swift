import Testing
@testable import AuthScope

@Suite
struct Scope_CollectionTests {
    @Test
    func indexComparison() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        #expect(scope.startIndex < scope.endIndex)
    }

    @Test
    func scopeIsEmpty() {
        #expect(Scope<TestAccessRange>().isEmpty)
        #expect(!Scope<TestAccessRange>(accessRanges: .a, .b, .c).isEmpty)
    }

    @Test
    func scopeStartIndex() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        #expect(scope.startIndex.setIndex == scope.accessRanges.startIndex)
    }

    @Test
    func scopeEndIndex() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        #expect(scope.endIndex.setIndex == scope.accessRanges.endIndex)
    }

    @Test
    func scopeIndexSubscript() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        let index = scope.index(after: scope.startIndex)
        #expect(scope[index] == scope.accessRanges[index.setIndex])
    }

    @Test
    func scopeIndexAfterCalculation() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        #expect(scope.index(after: scope.startIndex).setIndex == scope.accessRanges.index(after: scope.accessRanges.startIndex))
    }

    @Test
    func scopeFiltering() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        #expect(scope.filter { $0 == .a } == Scope(accessRanges: .a))
    }
}
