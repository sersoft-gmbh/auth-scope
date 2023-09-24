extension Scope: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let scopeString = try container.decode(String.self)
        do {
            try self.init(scopeString: scopeString)
        } catch {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath,
                                                    debugDescription: "Invalid scope string '\(scopeString)'",
                                                    underlyingError: error))
        }
    }
}

extension Scope: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(scopeString)
    }
}
