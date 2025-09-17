import Testing
import AuthScope

@Suite
struct Scope_DefaultsTests {
    @Test
    func scopeAllDefault() {
        #expect(Scope<TestAccessRange>.all == Scope(accessRanges: TestAccessRange.allCases))
    }
}
