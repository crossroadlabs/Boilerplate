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