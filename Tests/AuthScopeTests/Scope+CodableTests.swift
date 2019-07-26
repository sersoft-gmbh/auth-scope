import XCTest
import AuthScope

final class Scope_CodableTests: XCTestCase {
    private struct Wrapper: Codable {
        let scope: Scope<TestAccessRange>
    }

    func testScopeDecoding() throws {
        let json = #"{"scope": "a b c"}"#
        let scope = try JSONDecoder().decode(Wrapper.self, from: Data(json.utf8)).scope
        XCTAssertEqual(scope, [.a, .b, .c])
    }

    func testScopeEncoding() throws {
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        let json = try JSONEncoder().encode(Wrapper(scope: scope))
        let object = try JSONSerialization.jsonObject(with: json, options: [])
        XCTAssertTrue(object is [String: Any])
        if let dict = object as? [String: Any] {
            let value = dict["scope"]
            XCTAssertNotNil(value)
            XCTAssertTrue(value is String)
            XCTAssertEqual((value as? String)?.split(separator: " ").sorted(),
                           scope.scopeString.split(separator: " ").sorted())
        }
    }
}
