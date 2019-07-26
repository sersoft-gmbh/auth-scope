extension Scope: CustomStringConvertible {
    public var description: String {
        return String(describing: accessRanges.map { $0.rawValue }.sorted())
    }
}
