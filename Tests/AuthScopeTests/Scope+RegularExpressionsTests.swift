import XCTest
import AuthScope

fileprivate extension Scope {
    // necessary because it generates the same order as the underlying set
    var regExpGroupString: String {
        return map { $0.rawValue }.joined(separator: "|")
    }
}

final class Scope_RegularExpressionsTests: XCTestCase {
    func testScopeExactMatchRegExp() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        let groupString = scope.regExpGroupString
        XCTAssertEqual(scope.exactMatchRegExp, "^(?:\(groupString)) (?:\(groupString)) (?:\(groupString))$")
    }
    
    func testScopeContainsAllRegExp() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        let groupString = scope.regExpGroupString
        XCTAssertEqual(scope.containsAllRegExp,
                       "^(?:[^ ]+ )*(?:\(groupString)) (?:[^ ]+ )*(?:\(groupString)) (?:[^ ]+ )*(?:\(groupString))(?: (?:[^ ]+(?: |$))+|$)")
    }

    func testScopeContainsAnyRegExp() {
        let scope: Scope<TestAccessRange> = [.a, .b, .c]
        let groupString = scope.regExpGroupString
        XCTAssertEqual(scope.containsAnyRegExp, "(?:^| )(?:\(groupString))(?: |$)")
    }
}
