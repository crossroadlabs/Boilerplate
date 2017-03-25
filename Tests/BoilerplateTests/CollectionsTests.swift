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

/*
 * Test coming from issue https://github.com/crossroadlabs/Boilerplate/issues/7
 * Is here to make sure that Bolerplate zip does not collide with builtin zip function
 */
extension Dictionary {
    #if swift(>=3.0)
        init<S: Sequence> (_ seq: S) where S.Iterator.Element == Element {
            self.init()
            for (k, v) in seq {
                self[k] = v
            }
        }
    #else
        init<S: SequenceType where S.Generator.Element == Element> (_ seq: S) {
            self.init()
            for (k, v) in seq {
                self[k] = v
            }
        }
    #endif
    
    func mapValues<T>(transform: (Value)->T) -> Dictionary<Key,T> {
        #if swift(>=3.0)
            return zip(self.keys, self.values.map(transform))^
        #else
            return Dictionary<Key,T>(zip(self.keys, self.values.map(transform)))
        #endif
    }
}

class CollectionsTests: XCTestCase {
    func enumerateSome(callback:(String)->Void) {
        callback("one")
        callback("two")
        callback("three")
    }
    
    func testEnumerator() {
        let reference = ["one", "two", "three"]
        let array = Array(enumerator: enumerateSome)
        
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
        
        let dict1 = tuples.map(Tuple2.init(tuple:)).dictionary
        let dict2 = dict1.map { (k, v) in
            (k, v*v)
        }.map(Tuple2.init(tuple:)).dictionary
        
        XCTAssertEqual(dict1, reference2)
        XCTAssertEqual(dict2, reference1)
    }
}

#if os(Linux)
extension CollectionsTests {
	static var allTests : [(String, (CollectionsTests) -> () throws -> Void)] {
		return [
			("testEnumerator", testEnumerator),
			("testToMap", testToMap),
		]
	}
}
#endif
