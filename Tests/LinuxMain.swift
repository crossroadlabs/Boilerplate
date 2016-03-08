import XCTest

@testable import Boilerplatetest

XCTMain([
	NSBridgingTests(),
	OptionalTests(),
	ContainerTests(),
	AnyContainerTests(),
	CollectionsTests(),
	EquatableTests(),
])
