/// The error thrown when an access range is initialized with an invalid raw value.
public struct InvalidAccessRangeError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    /// The raw value of the access range that didn't pass validation.
    public let rawValue: String

    /// The type of the access range that was used to validate above's ``rawValue``.
    public let accessRangeType: Any.Type

    public var description: String {
        "The value '\(rawValue)' is not a valid scope access range!"
    }

    public var debugDescription: String {
        "The value '\(rawValue)' is not a valid scope access range of \(accessRangeType)!"
    }
}

/// Describes an access range type. Typically an enum.
public protocol AccessRangeProtocol: Sendable, RawRepresentable, Hashable
where RawValue == String
{
    /// Creates an access range with the given raw value or throws an error (typically ``InvalidAccessRangeError``) if it's not a valid raw value.
    /// - Parameter rawValue: The raw value to use for the access range.
    /// - Throws: Any error (typically ``InvalidAccessRangeError``) if it's not a vaild raw value.
    init(validating string: some StringProtocol) throws
}

extension AccessRangeProtocol {
    @inlinable
    internal init?(string: some StringProtocol) {
        self.init(rawValue: RawValue(string))
    }

    public init(validating string: some StringProtocol) throws {
        let rawValue = RawValue(string)
        guard let accessRange = Self(rawValue: rawValue)
        else { throw InvalidAccessRangeError(rawValue: rawValue, accessRangeType: Self.self) }
        self = accessRange
    }
}
