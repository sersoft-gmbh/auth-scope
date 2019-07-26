import XCTest
@testable import AuthScope

final class Scope_CollectionTests: XCTestCase {
    func testScopeIsEmpty() {
        XCTAssertTrue(Scope<TestAccessRange>().isEmpty)
        XCTAssertFalse(Scope<TestAccessRange>(accessRanges: .a, .b, .c).isEmpty)
    }

    func testScopeStartIndex() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        XCTAssertEqual(scope.startIndex, scope.accessRanges.startIndex)
    }

    func testScopeEndIndex() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        XCTAssertEqual(scope.endIndex, scope.accessRanges.endIndex)
    }

    func testScopeIndexSubscript() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        let index = scope.index(after: scope.startIndex)
        XCTAssertEqual(scope[index], scope.accessRanges[index])
    }

    func testScopeIndexAfterCalculation() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        XCTAssertEqual(scope.index(after: scope.startIndex), scope.accessRanges.index(after: scope.accessRanges.startIndex))
    }

    func testScopeFiltering() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        XCTAssertEqual(scope.filter { $0 == .a }, Scope(accessRanges: .a))
    }
}
