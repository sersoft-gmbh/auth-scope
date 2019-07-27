extension Scope: Decodable {
    public init(from decoder: Decoder) throws {
        try self.init(scopeString: decoder.singleValueContainer().decode(String.self))
    }
}

extension Scope: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(scopeString)
    }
}
