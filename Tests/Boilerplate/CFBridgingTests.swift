//
//  CFBridgingTests.swift
//  Boilerplate
//
//  Created by Yegor Popovych on 3/24/16.
//  Copyright © 2016 Crossroad Labs, LTD. All rights reserved.
//

import XCTest
import Foundation
import CoreFoundation

@testable import Boilerplate

class CFBridgingTests: XCTestCase {
    
    func testCFString() {
        let str = "somestring"
        let cfstr = str.cf
        let cfcopy = CFStringCreateWithBytes(nil, str, str.utf8.count, CFStringBuiltInEncodings.UTF8.rawValue, false)
        XCTAssert(CFStringCompare(cfstr, "somestring".cf, CFStringCompareFlags(rawValue: 0)) == .CompareEqualTo)
        XCTAssert(CFStringCompare(cfstr, "another".cf, CFStringCompareFlags(rawValue: 0)) != .CompareEqualTo)
        
        XCTAssert(CFStringCompare(cfstr, cfcopy, CFStringCompareFlags(rawValue: 0)) == .CompareEqualTo)
    }
}

#if os(Linux)
extension CFBridgingTests {
	static var allTests : [(String, CFBridgingTests -> () throws -> Void)] {
		return [
			("testCFString", testCFString),
		]
	}
}
#endif