import XCTest

@testable import BoilerplateTestSuite

XCTMain([
	testCase(AnyContainerTests.allTests),
	testCase(CFBridgingTests.allTests),
	testCase(CollectionsTests.allTests),
	testCase(ContainerTests.allTests),
	testCase(EquatableTests.allTests),
	testCase(NSBridgingTests.allTests),
	testCase(OptionalTests.allTests),
	testCase(ShimTests.allTests),
	testCase(ThreadTests.allTests),
	testCase(TimeTests.allTests),
])