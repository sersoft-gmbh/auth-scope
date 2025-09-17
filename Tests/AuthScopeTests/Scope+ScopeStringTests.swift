import Testing
@testable import AuthScope

@Suite
struct Scope_ScopeStringTests {
    @Test
    func scopeInitializerWithScopeString() throws {
        let scope = try Scope<TestAccessRange>(scopeString: "a b c d e f")
        #expect(scope.accessRanges == [.a, .b, .c, .d, .e, .f])
    }

    @Test
    func scopeStringCreation() throws {
        let scope = Scope<TestAccessRange>(accessRanges: .a, .b, .c, .d, .e, .f)
        #expect(scope.scopeString.split(separator: " ").sorted() == "a b c d e f".split(separator: " ").sorted())
    }

    @Test
    func scopeStringRoundtrip() throws {
        let scope = Scope<TestAccessRange>(accessRanges: .a, .b, .c, .d, .e, .f)
        #expect(try Scope(scopeString: scope.scopeString) == scope)
    }
}
