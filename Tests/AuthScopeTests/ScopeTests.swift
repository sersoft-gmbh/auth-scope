import XCTest
@testable import AuthScope

final class ScopeTests: XCTestCase {
    func testScopeInitializerWithAccessRangeSet() {
        let accessRanges: Set<TestAccessRange> = [.a, .b, .c, .d]
        let scope = Scope(accessRanges: accessRanges)
        XCTAssertEqual(scope.accessRanges, accessRanges)
    }

    func testScopeInitializerWithAccessRangeCollection() {
        let accessRanges: Array<TestAccessRange> = [.a, .b, .c, .d]
        let scope = Scope(accessRanges: accessRanges)
        XCTAssertEqual(scope.accessRanges, Set(accessRanges))
    }

    func testScopeInitializerWithAccessRangeVariadicList() {
        let scope = Scope<TestAccessRange>(accessRanges: .a, .b, .c, .d)
        XCTAssertEqual(scope.accessRanges, [.a, .b, .c, .d])
    }

    func testScopeEmptyInitializer() {
        let scope = Scope<TestAccessRange>()
        XCTAssertTrue(scope.accessRanges.isEmpty)
    }

    func testScopeEquatabilityIsBasedOnAccessRange() {
        let scope1 = Scope<TestAccessRange>(accessRanges: .a, .b, .c, .d)
        let scope2 = Scope<TestAccessRange>(accessRanges: .a, .b, .c, .d)
        let scope3 = Scope<TestAccessRange>(accessRanges: .a, .b, .c)
        XCTAssertEqual(scope1 == scope2, scope1.accessRanges == scope2.accessRanges)
        XCTAssertEqual(scope2 == scope3, scope2.accessRanges == scope3.accessRanges)
        XCTAssertEqual(scope1, scope2)
        XCTAssertNotEqual(scope2, scope3)
    }

    func testScopeHashingIsBasedOnAccessRange() {
        let scope = Scope<TestAccessRange>(accessRanges: .a, .b, .c, .d)
        var hasher = Hasher()
        hasher.combine(scope.accessRanges)
        XCTAssertEqual(hasher.finalize(), scope.hashValue)
    }
}
