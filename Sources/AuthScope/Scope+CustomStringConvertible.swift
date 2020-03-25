extension Scope: CustomStringConvertible {
    public var description: String {
        return String(describing: accessRanges.lazy.map { $0.rawValue }.sorted())
    }
}
