import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(KLBreakingBadAPITests.allTests),
        testCase(KLBreakingBadAPIDataTests.allTests),
    ]
}
#endif
