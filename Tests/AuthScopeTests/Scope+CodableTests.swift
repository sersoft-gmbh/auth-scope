import Foundation
import Testing
import AuthScope

@Suite
struct Scope_CodableTests {
    private struct Wrapper: Codable {
        let scope: Scope<TestAccessRange>
    }

    @Test
    func scopeSuccessfulDecoding() throws {
        let json = #"{"scope": "a b c"}"#
        let scope = try JSONDecoder().decode(Wrapper.self, from: Data(json.utf8)).scope
        #expect(scope == [.a, .b, .c])
    }

    @Test
    func scopeFailedDecodingDueToInvalidScopeString() throws {
        let json = #"{"scope": "x y z"}"#
        let error: DecodingError?
#if swift(>=6.1)
        error = #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(Wrapper.self, from: Data(json.utf8)).scope
        }
#else
        do {
            _ = try JSONDecoder().decode(Wrapper.self, from: Data(json.utf8)).scope
            error = nil
        } catch let caughtError as DecodingError {
            error = caughtError
        } catch {
            #expect(error is DecodingError) // Will always fail
            error = nil
        }
#endif
        switch try #require(error) {
        case .dataCorrupted(let ctx):
            #expect(ctx.codingPath.map(\.stringValue) == ["scope"])
            #expect(ctx.debugDescription == "Invalid scope string 'x y z'")
            let underlyingError = try #require(ctx.underlyingError as? InvalidAccessRangeError)
            #expect(underlyingError.accessRangeType is TestAccessRange.Type)
            #expect(underlyingError.rawValue == "x")
        case let other:
            Issue.record(other, "Invalid decoding error: \(other)")
        }
    }

    @Test
    func scopeEncoding() throws {
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        let json = try JSONEncoder().encode(Wrapper(scope: scope))
        let object = try JSONSerialization.jsonObject(with: json, options: [])
        let dict = try #require(object as? [String: Any])
        let value = try #require(dict["scope"])
        #expect((value as? String)?.split(separator: " ").sorted() == scope.scopeString.split(separator: " ").sorted())
    }
}
