import XCTest
import AuthScope

final class Scope_CodableTests: XCTestCase {
    private struct Wrapper: Codable {
        let scope: Scope<TestAccessRange>
    }

    func testScopeSuccessfulDecoding() throws {
        let json = #"{"scope": "a b c"}"#
        let scope = try JSONDecoder().decode(Wrapper.self, from: Data(json.utf8)).scope
        XCTAssertEqual(scope, [.a, .b, .c])
    }

    func testScopeFailedDecodingDueToInvalidScopeString() throws {
        let json = #"{"scope": "x y z"}"#
        XCTAssertThrowsError(try JSONDecoder().decode(Wrapper.self, from: Data(json.utf8)).scope) {
            guard let decodingError = $0 as? DecodingError else {
                XCTFail("Invalid error: \($0)")
                return
            }
            switch decodingError {
            case .dataCorrupted(let ctx):
                XCTAssertEqual(ctx.codingPath.map(\.stringValue), ["scope"])
                XCTAssertEqual(ctx.debugDescription, "Invalid scope string 'x y z'")
                XCTAssertNotNil(ctx.underlyingError)
                guard let underlyingError = ctx.underlyingError else { return }
                XCTAssertTrue(underlyingError is InvalidAccessRangeError)
                guard let invAccessRangeError = underlyingError as? InvalidAccessRangeError else { return }
                XCTAssertTrue(invAccessRangeError.accessRangeType == TestAccessRange.self)
                XCTAssertEqual(invAccessRangeError.rawValue, "x")
            case .keyNotFound(_, _), .valueNotFound(_, _), .typeMismatch(_, _):
                XCTFail("Invalid decoding error: \(decodingError)")
            @unknown default:
                XCTFail("Unknown decoding error: \(decodingError)")
            }
        }
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
