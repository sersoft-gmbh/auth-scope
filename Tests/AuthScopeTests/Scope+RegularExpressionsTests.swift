import Foundation
import Testing
import AuthScope

@Suite
struct Scope_RegularExpressionsTests {
    @Test
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    func scopeExactMatchRegex() throws {
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        #expect(try scope.exactMatchRegex.wholeMatch(in: scope.scopeString) != nil)
        #expect(try scope.exactMatchRegex.wholeMatch(in: "A a X") == nil)
        #expect(try scope.exactMatchRegex.wholeMatch(in: "a a a") == nil)
        #expect(try Scope<TestAccessRange>().exactMatchRegex.firstMatch(in: "a b c") == nil)
        #expect(try Scope<TestAccessRange>().exactMatchRegex.firstMatch(in: "") != nil)
    }

    @Test
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    func scopeContainsAllRegex() throws {
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        #expect(try scope.containsAllRegex.firstMatch(in: scope.scopeString) != nil)
        #expect(try scope.containsAllRegex.firstMatch(in: "A a X Y") == nil)
        #expect(try scope.containsAllRegex.firstMatch(in: "a a a") == nil)
        #expect(try scope.containsAllRegex.firstMatch(in: "A a X b x") == nil)
        #expect(try scope.containsAllRegex.firstMatch(in: "a b c d") != nil)
        #expect(try scope.containsAllRegex.firstMatch(in: "X a b c d") != nil)
        #expect(try scope.containsAllRegex.firstMatch(in: "X a b c d Y") != nil)
        #expect(try Scope<TestAccessRange>().containsAllRegex.firstMatch(in: "a b c") != nil)
        #expect(try Scope<TestAccessRange>().containsAllRegex.firstMatch(in: "") != nil)
    }

    @Test
    @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    func testScopeContainsAnyRegex() throws {
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        #expect(try scope.containsAnyRegex.firstMatch(in: scope.scopeString) != nil)
        #expect(try scope.containsAnyRegex.firstMatch(in: "A a X") != nil)
        #expect(try scope.containsAnyRegex.firstMatch(in: "a a a") != nil)
        #expect(try scope.containsAnyRegex.firstMatch(in: "a") != nil)
        #expect(try scope.containsAnyRegex.firstMatch(in: "b c") != nil)
        #expect(try scope.containsAnyRegex.firstMatch(in: "c") != nil)
        #expect(try scope.containsAnyRegex.firstMatch(in: "x c") != nil)
        #expect(try scope.containsAnyRegex.firstMatch(in: "X Y Z") == nil)
        #expect(try Scope<TestAccessRange>().containsAnyRegex.firstMatch(in: "a b c") != nil)
        #expect(try Scope<TestAccessRange>().containsAnyRegex.firstMatch(in: "") != nil)
    }

    @Test
    func scopeExactMatchRegexPattern() throws {
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        let regex = try NSRegularExpression(pattern: scope.exactMatchRegexPattern)
        #expect(regex.wholeMatch(in: scope.scopeString) != nil)
        #expect(regex.wholeMatch(in: "A a X") == nil)
        #expect(regex.wholeMatch(in: "a a a") == nil)
        #expect(Scope<TestAccessRange>().exactMatchRegexPattern == "^$")
    }

    @Test
    func scopeContainsAllRegexPattern() throws {
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        let regex = try NSRegularExpression(pattern: scope.containsAllRegexPattern)
        #expect(regex.firstMatch(in: scope.scopeString) != nil)
        #expect(regex.firstMatch(in: "A a X Y") == nil)
        #expect(regex.firstMatch(in: "a a a") == nil)
        #expect(regex.firstMatch(in: "A a X b x") == nil)
        #expect(regex.firstMatch(in: "a b c d") != nil)
        #expect(regex.firstMatch(in: "X a b c d") != nil)
        #expect(regex.firstMatch(in: "X a b c d Y") != nil)
        #expect(Scope<TestAccessRange>().containsAllRegexPattern == "^.*$")
    }

    @Test
    func scopeContainsAnyRegexPattern() throws {
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        let regex = try NSRegularExpression(pattern: scope.containsAnyRegexPattern)
        #expect(regex.firstMatch(in: scope.scopeString) != nil)
        #expect(regex.firstMatch(in: "A a X") != nil)
        #expect(regex.firstMatch(in: "a a a") != nil)
        #expect(regex.firstMatch(in: "a") != nil)
        #expect(regex.firstMatch(in: "b c") != nil)
        #expect(regex.firstMatch(in: "c") != nil)
        #expect(regex.firstMatch(in: "x c") != nil)
        #expect(regex.firstMatch(in: "X Y Z") == nil)
        #expect(Scope<TestAccessRange>().containsAnyRegexPattern == "^.*$")
    }
}

fileprivate extension NSRegularExpression {
    func firstMatch(in string: some StringProtocol) -> NSTextCheckingResult? {
        let str = String(string)
        return firstMatch(in: str, range: NSRange(str.startIndex..<str.endIndex, in: str))
    }

    func wholeMatch(in string: some StringProtocol) -> NSTextCheckingResult? {
        let str = String(string)
        let range = NSRange(str.startIndex..<str.endIndex, in: str)
        let allMatches = matches(in: str, range: range)
        guard allMatches.count == 1, allMatches[0].range == range else { return nil }
        return allMatches[0]
    }
}
