import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ytdl_serverTests.allTests),
    ]
}
#endif
