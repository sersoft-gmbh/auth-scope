import XCTest
@testable import AuthScope

final class Scope_ScopeStringTests: XCTestCase {
    func testScopeInitializerWithScopeString() throws {
        let scope = try Scope<TestAccessRange>(scopeString: "a b c d e f")
        XCTAssertEqual(scope.accessRanges, [.a, .b, .c, .d, .e, .f])
    }

    func testScopeStringCreation() throws {
        let scope = Scope<TestAccessRange>(accessRanges: .a, .b, .c, .d, .e, .f)
        XCTAssertEqual(scope.scopeString.split(separator: " ").sorted(),
                       "a b c d e f".split(separator: " ").sorted())
    }

    func testScopeStringRoundtrip() {
        let scope = Scope<TestAccessRange>(accessRanges: .a, .b, .c, .d, .e, .f)
        XCTAssertEqual(try Scope(scopeString: scope.scopeString), scope)
    }
}
