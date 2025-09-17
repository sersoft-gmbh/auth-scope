import Testing
import AuthScope

@Suite
struct Scope_CustomStringConvertibleTests {
    @Test
    func scopeDescription() {
        let accessRanges: Set<TestAccessRange> = [.a, .b, .c]
        let scope = Scope(accessRanges: accessRanges)
        #expect(scope.description == String(describing: accessRanges.map(\.rawValue).sorted()))
    }

    @Test
    func scopeDebugDescription() {
        let accessRanges: Set<TestAccessRange> = [.d, .e, .f]
        let scope = Scope(accessRanges: accessRanges)
        #expect(scope.debugDescription == "Scope<\(TestAccessRange.self)> { \(accessRanges.map(\.rawValue).sorted().joined(separator: ", ")) }")
    }
}
