extension Scope: CustomStringConvertible, CustomDebugStringConvertible {
    /// See `CustomStringConvertible.description`
    public var description: String {
        String(describing: accessRanges.lazy.map(\.rawValue).sorted())
    }

    /// See `CustomDebugStringConvertible.debugDescription`
    public var debugDescription: String {
        "Scope<\(AccessRange.self)> { \(accessRanges.lazy.map(\.rawValue).sorted().joined(separator: ", ")) }"
    }
}
