import XCTest
import AuthScope

final class Scope_CustomStringConvertibleTests: XCTestCase {
    func testScopeDescription() {
        let accessRanges: Set<TestAccessRange> = [.a, .b, .c]
        let scope = Scope(accessRanges: accessRanges)
        XCTAssertEqual(scope.description, String(describing: accessRanges.map { $0.rawValue }.sorted()))
    }
}
