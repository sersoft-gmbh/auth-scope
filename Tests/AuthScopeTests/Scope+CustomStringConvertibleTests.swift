import XCTest
import AuthScope

final class Scope_CustomStringConvertibleTests: XCTestCase {
    func testScopeDescription() {
        let accessRanges: Set<TestAccessRange> = [.a, .b, .c]
        let scope = Scope(accessRanges: accessRanges)
        XCTAssertEqual(scope.description, String(describing: accessRanges.map(\.rawValue).sorted()))
    }

    func testScopeDebugDescription() {
        let accessRanges: Set<TestAccessRange> = [.d, .e, .f]
        let scope = Scope(accessRanges: accessRanges)
        XCTAssertEqual(scope.debugDescription, "Scope<\(TestAccessRange.self)> { \(accessRanges.map(\.rawValue).sorted().joined(separator: ", ")) }")
    }
}
