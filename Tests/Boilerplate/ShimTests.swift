//
//  ShimTests.swift
//  Boilerplate
//
//  Created by Daniel Leping on 23/03/2016.
//  Copyright © 2016 Crossroad Labs, LTD. All rights reserved.
//

import XCTest
import Foundation
import Result

@testable import Boilerplate

class ShimTests: XCTestCase {
    func testSequenseJoin() {
        let joined = ["a", "b"].joined(separator: "|")
        
        XCTAssertEqual("a|b", joined)
    }
    
    func testAdvancedBy() {
        let array = ["a", "b", "c"]
        
        let start = array.startIndex
        let one = start.advanced(by: 1)
        let two = start.advanced(by: 2)
        let twoWithLimit = start.advanced(by:3, limit: 2)
        
        XCTAssertEqual(one, 1)
        XCTAssertEqual(two, 2)
        XCTAssertEqual(twoWithLimit, two)
        
        let string = "string"
        
        let withLimit = string.startIndex.advanced(by:10, limit: string.endIndex)
        XCTAssertEqual(withLimit, string.endIndex)
    }
    
    func testDistanceTo() {
        let array = ["a", "b", "c"]
        
        XCTAssertEqual(array.startIndex.distance(to: array.endIndex), 3)
    }
    
    func testArrayMutation() {
        var array = ["a", "b", "c"]
        
        array.append(contentsOf: ["e"])
        
        XCTAssertEqual(array, ["a", "b", "c", "e"])
        
        array.insert("d", at: 3)
        
        XCTAssertEqual(array, ["a", "b", "c", "d", "e"])
        
        array.remove(at: 2)
        
        XCTAssertEqual(array, ["a", "b", "d", "e"])
        
        let capacity = array.capacity
        var array2 = array
        let capacity2 = array2.capacity
        
        array.removeAll(keepingCapacity: true)
        array2.removeAll(keepingCapacity: false)
        
        XCTAssertEqual(array, array2)
        XCTAssertEqual(array, [])
        
        XCTAssertEqual(array.capacity, capacity)
        XCTAssertNotEqual(array2.capacity, capacity2)
    }
    
    func testCollectionPrefixes() {
        let array = ["a", "b", "b", "c"]
        
        XCTAssertEqual(array.prefix(upTo: 1), ["a"])
        XCTAssertEqual(array.prefix(through: 1), ["a", "b"])
        XCTAssertEqual(array.suffix(from: 2), ["b", "c"])
        
        let defaultSplit = array.split { element in
            element == "b"
        }
        
        let ommitingSplit = array.split(omittingEmptySubsequences: true) { element in
            element == "b"
        }
        
        let withEmptySplit = array.split(omittingEmptySubsequences: false) { element in
            element == "b"
        }
        
        let limitedSplit = array.split(maxSplits: 0, omittingEmptySubsequences: true) { element in
            element == "b"
        }
        
        XCTAssertEqual(defaultSplit.count, 2)
        XCTAssertEqual(ommitingSplit.count, 2)
        XCTAssertEqual(withEmptySplit.count, 3)
        XCTAssertEqual(limitedSplit.count, 1)
    }
    
    func testStringCase() {
        let hello = "Hello"
        
        XCTAssertEqual(hello.uppercased(), "HELLO")
        XCTAssertEqual(hello.lowercased(), "hello")
    }
    
    func testStringSubstring() {
        let hello = "Hello, World!"
        XCTAssertEqual(hello.substring(with:hello.startIndex.advanced(by:3)..<hello.endIndex.advanced(by:-3)), "lo, Wor")
        XCTAssertEqual(hello.substring(from:hello.startIndex.advanced(by:3)), "lo, World!")
        XCTAssertEqual(hello.substring(to:hello.endIndex.advanced(by:-3)), "Hello, Wor")
    }
    
    func testStringByteArray() {
        let ansi:[Int8] = [0x30, 0x31, 0x32, 0x33, 0x34, 0]
        let badUTF8:[Int8] = [0x30, 0x31, 0x32, 0x33, 0x34, Int8(bitPattern:254), Int8(bitPattern:0x80), 0x35, 0]
        let goodUTF8:[Int8] = [0x30, 0x31, 0x32, 0x33, 0x34, 0x35, Int8(bitPattern:0xc2), Int8(bitPattern:0xa9), 0]
        
        XCTAssertEqual(String(cString: ansi), "01234")
        XCTAssertEqual(String(cString: badUTF8), "01234\u{FFFD}\u{FFFD}5")
        XCTAssertEqual(String(cString: goodUTF8), "012345©")
        
        XCTAssertEqual(String(validatingUTF8:ansi), "01234")
        XCTAssertEqual(String(validatingUTF8: badUTF8), nil)
        XCTAssertEqual(String(validatingUTF8: goodUTF8), "012345©")
    }
    
    func testStringAppend() {
        var string = "begin"
        let end = "end"
        let mid:[Character] = ["m", "i", "d"]
        
        string.append(contentsOf: mid)
        
        XCTAssertEqual("beginmid", string)
        
        string.append(end)
        
        XCTAssertEqual("beginmidend", string)
    }
    
    func testStringEncoding() {
        #if swift(>=3.0) && !os(Linux)
            let expectation = self.expectation(withDescription: "desc")
        #else
            let expectation = self.expectationWithDescription("desc")
        #endif
        

        UTF8.encode("A", sendingOutputTo: { unit in
            XCTAssertEqual(unit, 65)
            expectation.fulfill()
        })
        
        #if swift(>=3.0) && !os(Linux)
            self.waitForExpectations(withTimeout: 0, handler: nil)
        #else
            self.waitForExpectationsWithTimeout(0, handler: nil)
        #endif
    }
}

#if os(Linux)
extension ShimTests {
	static var allTests : [(String, ShimTests -> () throws -> Void)] {
		return [
			("testSequenseJoin", testSequenseJoin),
			("testAdvancedBy", testAdvancedBy),
			("testArrayMutation", testArrayMutation),
			("testCollectionPrefixes", testCollectionPrefixes),
			("testStringCase", testStringCase),
			("testStringSubstring", testStringSubstring),
			("testStringByteArray", testStringByteArray),
			("testStringAppend", testStringAppend),
			("testStringEncoding", testStringEncoding),
		]
	}
}
#endif