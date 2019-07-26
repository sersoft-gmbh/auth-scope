import XCTest
import AuthScope

final class Scope_DefaultsTests: XCTestCase {
    func testScopeAllDefault() {
        XCTAssertEqual(Scope<TestAccessRange>.all, Scope(accessRanges: TestAccessRange.allCases))
    }
}
