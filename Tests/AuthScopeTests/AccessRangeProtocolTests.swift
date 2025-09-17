import Testing
import AuthScope

@Suite
struct AccessRangeProtocolTests {
    private enum AccessRange: String, AccessRangeProtocol {
        case testValue
    }

    @Test
    func accessRangeProtocolDefaultInitWithValidRawValue() throws {
        #expect(try AccessRange(validating: AccessRange.testValue.rawValue) == .testValue)
    }

    @Test
    func accessRangeProtocolDefaultInitWithInvalidRawValue() {
        let invalidRawValue = "invalid"

#if swift(>=6.1)
        let error = #expect(throws: InvalidAccessRangeError.self) {
            try AccessRange(validating: invalidRawValue)
        }
#else
        let error: InvalidAccessRangeError?
        do {
            _ = try AccessRange(validating: invalidRawValue)
            error = nil
        } catch let caughtError as InvalidAccessRangeError {
            error = caughtError
        } catch {
            #expect(error is InvalidAccessRangeError) // Will always fail
        }
#endif
        #expect(error?.rawValue == invalidRawValue)
        #expect(error?.accessRangeType == AccessRange.self)
        #expect(error?.description == "The value '\(invalidRawValue)' is not a valid scope access range!")
        #expect(error?.debugDescription == "The value '\(invalidRawValue)' is not a valid scope access range of \(AccessRange.self)!")
    }
}
