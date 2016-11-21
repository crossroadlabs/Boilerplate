import XCTest

#if os(Linux)
public func allTests() -> [XCTestCaseEntry] {
	 return [
		testCase(AnyContainerTests.allTests),
		testCase(CFBridgingTests.allTests),
		testCase(CollectionsTests.allTests),
		testCase(ContainerTests.allTests),
		testCase(EquatableTests.allTests),
		testCase(NSBridgingTests.allTests),
		testCase(NullTests.allTests),
		testCase(OptionalTests.allTests),
		testCase(ShimTests.allTests),
		testCase(TaskTests.allTests),
		testCase(ThreadTests.allTests),
		testCase(TimeTests.allTests)
	]
}
#endif