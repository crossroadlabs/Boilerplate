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
}