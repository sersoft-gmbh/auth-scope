extension Scope: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        String(describing: accessRanges.lazy.map(\.rawValue).sorted())
    }

    public var debugDescription: String {
        "Scope<\(AccessRange.self)> { \(accessRanges.lazy.map(\.rawValue).sorted().joined(separator: ", ")) }"
    }
}
