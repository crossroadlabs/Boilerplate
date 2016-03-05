//
//  NSBridgingTests.swift
//  Boilerplate
//
//  Created by Daniel Leping on 3/5/16.
//  Copyright © 2016 Crossroad Labs, LTD. All rights reserved.
//

import XCTest
import Foundation

@testable import Boilerplate

class NSBridgingTests: XCTestCase {
    
    func testStringBridging() {
        XCTAssert("mystring".ns.dynamicType.isSubclassOfClass(NSString.self))
    }
    
    func testArrayBridging() {
        let array = ["element"]
        let nsArray:Any = array.ns
        let swiftArray:Any = array
        XCTAssertFalse(swiftArray is NSArray)
        XCTAssertTrue(nsArray is NSArray)
    }
    
    func testDictionaryBridging() {
        XCTAssertTrue(["key": "value"].ns.dynamicType.isSubclassOfClass(NSDictionary.self))
    }
}

#if os(Linux)
extension NSBridgingTests : XCTestCaseProvider {
	var allTests : [(String, () throws -> Void)] {
		return [
			("testStringBridging", testStringBridging),
			("testArrayBridging", testArrayBridging),
			("testDictionaryBridging", testDictionaryBridging),
		]
	}
}
#endif