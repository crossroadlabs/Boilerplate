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
    
    func testIsNoBridge() {
        XCTAssertFalse(isNoBridge("string", type: NSString.self))
        XCTAssert(isNoBridge("string".ns, type: NSString.self))
    }
    
    func testAsNoBridge() {
        let nsStringNil:NSString? = asNoBridge("string")
        XCTAssertNil(nsStringNil)
        
        let nsString:NSString? = asNoBridge("string".ns)
        XCTAssertNotNil(nsString)
        
        XCTAssertNil(asNoBridge("string", type: NSString.self))
        
        XCTAssertNotNil(asNoBridge("string".ns, type: NSString.self))
    }
    
    func testStringBridging() {
        XCTAssert(isNoBridge("mystring".ns, type: NSString.self))
    }
    
    func testArrayBridging() {
        XCTAssert(isNoBridge(["element"].ns, type: NSArray.self))
    }
    
    func testDictionaryBridging() {
        XCTAssert(isNoBridge(["key": "value"].ns, type: NSDictionary.self))
    }
}

#if os(Linux)
extension NSBridgingTests {
	static var allTests : [(String, NSBridgingTests -> () throws -> Void)] {
		return [
			("testIsNoBridge", testIsNoBridge),
			("testAsNoBridge", testAsNoBridge),
			("testStringBridging", testStringBridging),
			("testArrayBridging", testArrayBridging),
			("testDictionaryBridging", testDictionaryBridging),
		]
	}
}
#endif