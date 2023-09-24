import XCTest
import AuthScope

fileprivate extension Scope {
    // necessary because it generates the same order as the underlying set
    var regexGroupString: String {
        lazy.map(\.rawValue).joined(separator: "|")
    }
}

final class Scope_RegularExpressionsTests: XCTestCase {
    func testScopeExactMatchRegex() throws {
        guard #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
        else { throw XCTSkip("Tested API not available!") }
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        XCTAssertNotNil(try scope.exactMatchRegex.wholeMatch(in: scope.scopeString))
        XCTAssertNil(try scope.exactMatchRegex.wholeMatch(in: "A a X"))
//        XCTAssertNil(try scope.exactMatchRegex.wholeMatch(in: "a a a"))
    }

    func testScopeContainsAllRegex() throws {
        guard #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
        else { throw XCTSkip("Tested API not available!") }
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        XCTAssertNotNil(try scope.containsAllRegex.firstMatch(in: scope.scopeString))
        XCTAssertNil(try scope.containsAllRegex.firstMatch(in: "A a X Y"))
//        XCTAssertNil(try scope.containsAllRegex.firstMatch(in: "a a a"))
//        XCTAssertNil(try scope.containsAllRegex.firstMatch(in: "A a X b x"))
        XCTAssertNotNil(try scope.containsAllRegex.firstMatch(in: "a b c d"))
        XCTAssertNotNil(try scope.containsAllRegex.firstMatch(in: "X a b c d"))
        XCTAssertNotNil(try scope.containsAllRegex.firstMatch(in: "X a b c d Y"))
    }

    func testScopeContainsAnyRegex() throws {
        guard #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
        else { throw XCTSkip("Tested API not available!") }
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        XCTAssertNotNil(try scope.containsAnyRegex.firstMatch(in: scope.scopeString))
        XCTAssertNotNil(try scope.containsAnyRegex.firstMatch(in: "A a X"))
        XCTAssertNotNil(try scope.containsAnyRegex.firstMatch(in: "a a a"))
        XCTAssertNotNil(try scope.containsAnyRegex.firstMatch(in: "a"))
        XCTAssertNotNil(try scope.containsAnyRegex.firstMatch(in: "b c"))
        XCTAssertNotNil(try scope.containsAnyRegex.firstMatch(in: "c"))
        XCTAssertNotNil(try scope.containsAnyRegex.firstMatch(in: "x c"))
        XCTAssertNil(try scope.containsAnyRegex.firstMatch(in: "X Y Z"))
    }

    func testScopeExactMatchRegexPattern() throws {
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        let groupString = scope.regexGroupString
        XCTAssertEqual(scope.exactMatchRegexPattern, "^(?:\(groupString)) (?:\(groupString)) (?:\(groupString))$")
        let regex = try NSRegularExpression(pattern: scope.exactMatchRegexPattern)
        XCTAssertNotNil(regex.wholeMatch(in: scope.scopeString))
        XCTAssertNil(regex.wholeMatch(in: "A a X"))
//        XCTAssertNil(regex.wholeMatch(in: "a a a"))
    }
    
    func testScopeContainsAllRegexPattern() throws {
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        let groupString = scope.regexGroupString
        XCTAssertEqual(scope.containsAllRegexPattern,
                       "^(?:[^ ]+ )*(?:\(groupString)) (?:[^ ]+ )*(?:\(groupString)) (?:[^ ]+ )*(?:\(groupString))(?: (?:[^ ]+(?: |$))+|$)")
        let regex = try NSRegularExpression(pattern: scope.containsAllRegexPattern)
        XCTAssertNotNil(regex.firstMatch(in: scope.scopeString))
        XCTAssertNil(regex.firstMatch(in: "A a X Y"))
//        XCTAssertNil(regex.firstMatch(in: "a a a"))
//        XCTAssertNil(regex.firstMatch(in: "A a X b x"))
        XCTAssertNotNil(regex.firstMatch(in: "a b c d"))
        XCTAssertNotNil(regex.firstMatch(in: "X a b c d"))
        XCTAssertNotNil(regex.firstMatch(in: "X a b c d Y"))
    }

    func testScopeContainsAnyRegexPattern() throws {
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        let groupString = scope.regexGroupString
        XCTAssertEqual(scope.containsAnyRegexPattern, "(?:^| )(?:\(groupString))(?: |$)")
        let regex = try NSRegularExpression(pattern: scope.containsAnyRegexPattern)
        XCTAssertNotNil(regex.firstMatch(in: scope.scopeString))
        XCTAssertNotNil(regex.firstMatch(in: "A a X"))
        XCTAssertNotNil(regex.firstMatch(in: "a a a"))
        XCTAssertNotNil(regex.firstMatch(in: "a"))
        XCTAssertNotNil(regex.firstMatch(in: "b c"))
        XCTAssertNotNil(regex.firstMatch(in: "c"))
        XCTAssertNotNil(regex.firstMatch(in: "x c"))
        XCTAssertNil(regex.firstMatch(in: "X Y Z"))
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
