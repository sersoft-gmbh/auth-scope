extension Scope: Decodable {
    /// See: `Decodable.init(from:)`
    public init(from decoder: Decoder) throws {
        let scopeString = try decoder.singleValueContainer().decode(String.self)
        do {
            try self.init(scopeString: scopeString)
        } catch {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath,
                                                    debugDescription: "Invalid scope string '\(scopeString)'",
                                                    underlyingError: error))
        }
    }
}

extension Scope: Encodable {
    /// See: `Encodable.encode(to:)`
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(scopeString)
    }
}
