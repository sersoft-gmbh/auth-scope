import XCTest
@testable import AuthScope

final class Scope_CollectionTests: XCTestCase {
    func testIndexComparison() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        XCTAssertTrue(scope.startIndex < scope.endIndex)
    }

    func testScopeIsEmpty() {
        XCTAssertTrue(Scope<TestAccessRange>().isEmpty)
        XCTAssertFalse(Scope<TestAccessRange>(accessRanges: .a, .b, .c).isEmpty)
    }

    func testScopeStartIndex() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        XCTAssertEqual(scope.startIndex.setIndex, scope.accessRanges.startIndex)
    }

    func testScopeEndIndex() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        XCTAssertEqual(scope.endIndex.setIndex, scope.accessRanges.endIndex)
    }

    func testScopeIndexSubscript() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        let index = scope.index(after: scope.startIndex)
        XCTAssertEqual(scope[index], scope.accessRanges[index.setIndex])
    }

    func testScopeIndexAfterCalculation() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        XCTAssertEqual(scope.index(after: scope.startIndex).setIndex, scope.accessRanges.index(after: scope.accessRanges.startIndex))
    }

    func testScopeFiltering() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        XCTAssertEqual(scope.filter { $0 == .a }, Scope(accessRanges: .a))
    }
}
