//
//  CollectionsTests.swift
//  Boilerplate
//
//  Created by Daniel Leping on 3/6/16.
//  Copyright © 2016 Crossroad Labs, LTD. All rights reserved.
//

import XCTest
import Foundation
import Result

@testable import Boilerplate

class CollectionsTests: XCTestCase {
    func enumerateSome(callback:(String)->Void) {
        callback("one")
        callback("two")
        callback("three")
    }
    
    func testEnumerator() {
        let reference = ["one", "two", "three"]
        let array = Array(enumerator: enumerateSome)
        
        let ss = reference.startIndex
        
        ss.advanced(by: 1)
        
        XCTAssertEqual(array, reference)
    }
    
    func testToMap() {
        let tuples = [("one", 1), ("two", 2), ("three", 3)]
        let reference1 = ["one": 1, "two": 4, "three": 9]
        let reference2 = ["one": 1, "two": 2, "three": 3]
        
        let map1 = tuples^.map { (k, v) in
            return (k, v*v)
        }^
        let map2 = toMap(tuples)
        
        XCTAssertEqual(map1, reference1)
        XCTAssertEqual(map2, reference2)
    }
}

#if os(Linux)
extension CollectionsTests {
	static var allTests : [(String, CollectionsTests -> () throws -> Void)] {
		return [
			("testEnumerator", testEnumerator),
		]
	}
}
#endif