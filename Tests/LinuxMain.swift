import XCTest

@testable import BoilerplateTestSuite

XCTMain([
	testCase(AnyContainerTests.allTests),
	testCase(EquatableTests.allTests),
	testCase(NullTests.allTests),
	testCase(NSBridgingTests.allTests),
	testCase(TimeTests.allTests),
	testCase(ContainerTests.allTests),
	testCase(ShimTests.allTests),
	testCase(OptionalTests.allTests),
	testCase(CFBridgingTests.allTests),
	testCase(CollectionsTests.allTests),
	testCase(ThreadTests.allTests),
])