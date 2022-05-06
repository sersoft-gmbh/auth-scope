extension Scope: CustomStringConvertible, CustomDebugStringConvertible {
    /// See ``Swift/CustomStringConvertible/description``
    public var description: String {
        String(describing: accessRanges.lazy.map(\.rawValue).sorted())
    }

    /// See ``Swift/CustomDebugStringConvertible/debugDescription``
    public var debugDescription: String {
        "Scope<\(AccessRange.self)> { \(accessRanges.lazy.map(\.rawValue).sorted().joined(separator: ", ")) }"
    }
}
