import XCTest
import AuthScope

final class Scope_SetAlgebraTests: XCTestCase {
    func testScopeCreationWithArrayLiteral() {
        XCTAssertEqual([.a, .b, .c], Scope<TestAccessRange>(accessRanges: [.a, .b, .c] as Set))
    }

    func testScopeUnion() {
        let scope1: Scope<TestAccessRange> = [.a, .b, .c]
        let scope2: Scope<TestAccessRange> = [.c, .d, .e]
        XCTAssertEqual(scope1.union(scope2), [.a, .b, .c, .d, .e])
    }

    func testScopeUnionForming() {
        var scope: Scope<TestAccessRange> = [.a, .b, .c]
        scope.formUnion([.c, .d, .e])
        XCTAssertEqual(scope, [.a, .b, .c, .d, .e])
    }

    func testScopeIntersection() {
        let scope1: Scope<TestAccessRange> = [.a, .b, .c, .d]
        let scope2: Scope<TestAccessRange> = [.c, .d, .e, .f]
        XCTAssertEqual(scope1.intersection(scope2), [.c, .d])
    }

    func testScopeIntersectionForming() {
        var scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        scope.formIntersection([.c, .d, .e, .f])
        XCTAssertEqual(scope, [.c, .d])
    }

    func testScopeSymmetricDifference() {
        let scope1: Scope<TestAccessRange> = [.a, .b, .c, .d]
        let scope2: Scope<TestAccessRange> = [.c, .d, .e, .f]
        XCTAssertEqual(scope1.symmetricDifference(scope2), [.a, .b, .e, .f])
    }

    func testScopeSymmetricDifferenceForming() {
        var scope: Scope<TestAccessRange> = [.a, .b, .c, .d]
        scope.formSymmetricDifference([.c, .d, .e, .f])
        XCTAssertEqual(scope, [.a, .b, .e, .f])
    }

    func testScopeInsertion() {
        var scope: Scope<TestAccessRange> = [.a, .b, .c]

        let result1 = scope.insert(.d)
        XCTAssertEqual(scope, [.a, .b, .c, .d])
        XCTAssertTrue(result1.inserted)
        XCTAssertEqual(result1.memberAfterInsert, .d)

        let result2 = scope.insert(.d)
        XCTAssertEqual(scope, [.a, .b, .c, .d])
        XCTAssertFalse(result2.inserted)
        XCTAssertEqual(result2.memberAfterInsert, .d)
    }

    func testScopeUpdate() {
        var scope: Scope<TestAccessRange> = [.a, .b, .c]

        let result1 = scope.update(with: .d)
        XCTAssertEqual(scope, [.a, .b, .c, .d])
        XCTAssertNil(result1)

        let result2 = scope.update(with: .d)
        XCTAssertEqual(scope, [.a, .b, .c, .d])
        XCTAssertNotNil(result2)
        XCTAssertEqual(result2, .d)
    }

    func testScopeRemoval() {
        var scope: Scope<TestAccessRange> = [.a, .b, .c, .d]

        let result1 = scope.remove(.d)
        XCTAssertEqual(scope, [.a, .b, .c])
        XCTAssertNotNil(result1)
        XCTAssertEqual(result1, .d)

        let result2 = scope.remove(.d)
        XCTAssertEqual(scope, [.a, .b, .c])
        XCTAssertNil(result2)
    }
}
