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
    
    #if os(Linux)
    func testCFString() {
        let str = "somestring"
        let cfstr = str.cf
        let cfcopy = CFStringCreateWithBytes(nil, str, str.utf8.count, UInt32(kCFStringEncodingUTF8), false)
        XCTAssert(CFStringCompare(cfstr, "somestring".cf, 0) == kCFCompareEqualTo)
        XCTAssert(CFStringCompare(cfstr, "another".cf, 0) != kCFCompareEqualTo)
        
        XCTAssert(CFStringCompare(cfstr, cfcopy, 0) == kCFCompareEqualTo)
    }
    #else
    #if swift(>=3.0)
        func testCFString() {
            let str = "somestring"
            let cfstr = str.cf
            let cfcopy = CFStringCreateWithBytes(nil, str, str.utf8.count, CFStringBuiltInEncodings.UTF8.rawValue, false)
            XCTAssert(CFStringCompare(cfstr, "somestring".cf, CFStringCompareFlags(rawValue: 0)) == .compareEqualTo)
            XCTAssert(CFStringCompare(cfstr, "another".cf, CFStringCompareFlags(rawValue: 0)) != .compareEqualTo)
        
            XCTAssert(CFStringCompare(cfstr, cfcopy, CFStringCompareFlags(rawValue: 0)) == .compareEqualTo)
        }
    #else
        func testCFString() {
            let str = "somestring"
            let cfstr = str.cf
            let cfcopy = CFStringCreateWithBytes(nil, str, str.utf8.count, CFStringBuiltInEncodings.UTF8.rawValue, false)
            XCTAssert(CFStringCompare(cfstr, "somestring".cf, CFStringCompareFlags(rawValue: 0)) == .CompareEqualTo)
            XCTAssert(CFStringCompare(cfstr, "another".cf, CFStringCompareFlags(rawValue: 0)) != .CompareEqualTo)
        
            XCTAssert(CFStringCompare(cfstr, cfcopy, CFStringCompareFlags(rawValue: 0)) == .CompareEqualTo)
        }
    #endif
    #endif
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