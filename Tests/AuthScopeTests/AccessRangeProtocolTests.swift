import XCTest
import AuthScope

final class AccessRangeProtocolTests: XCTestCase {
    private enum AccessRange: String, AccessRangeProtocol {
        case testValue
    }

    func testAccessRangeProtocolDefaultInitWithValidRawValue() throws {
        let range = try AccessRange(validating: AccessRange.testValue.rawValue)
        XCTAssertEqual(range, .testValue)
    }

    func testAccessRangeProtocolDefaultInitWithInvalidRawValue() {
        let invalidRawValue = "invalid"
        XCTAssertThrowsError(try AccessRange(validating: invalidRawValue)) {
            XCTAssertTrue($0 is InvalidAccessRangeError)
            if let accessRangeError = $0 as? InvalidAccessRangeError {
                XCTAssertEqual(accessRangeError.rawValue, invalidRawValue)
                XCTAssertTrue(accessRangeError.accessRangeType == AccessRange.self)
                XCTAssertEqual(accessRangeError.description, "The value '\(invalidRawValue)' is not a valid scope access range!")
                XCTAssertEqual(accessRangeError.debugDescription, "The value '\(invalidRawValue)' is not a valid scope access range of \(AccessRange.self)!")
            }
        }
    }
}
