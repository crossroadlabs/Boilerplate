//
//  OptionalTests.swift
//  Boilerplate
//
//  Created by Daniel Leping on 3/5/16.
//  Copyright © 2016 Crossroad Labs, LTD. All rights reserved.
//

import XCTest
import Foundation

@testable import Boilerplate

class OptionalTests: XCTestCase {
    
    func testGetOrElse() {
        let existingString:String? = "exists"
        
        XCTAssertEqual(existingString.getOr(else: "else"), "exists")
        
        let nilString:String? = nil
        
        XCTAssertNil(nilString)
        
        XCTAssertEqual(nilString.getOr(else: "else"), "else")
        
        let noAutoclosure = nilString.getOr {
            "else"
        }
        
        XCTAssertEqual(noAutoclosure, "else")
    }
    
    func testOrElse() {
        let existingString:String? = "exists"
        
        XCTAssertNotNil(existingString)
        XCTAssertNotNil(existingString.or(else: nil))
        
        let nilString:String? = nil
        
        XCTAssertNil(nilString)
        XCTAssertNil(nilString.or(else: nil))
        XCTAssertNotNil(nilString.or(else: existingString))
        
        let noAutoclosureNil = nilString.or {
            nil
        }
        
        XCTAssertNil(noAutoclosureNil)
        
        let noAutoclosure = nilString.or {
            existingString
        }
        
        XCTAssertNotNil(noAutoclosure)
    }
    
    func testFilter() {
        let op:String? = "some"
        
        XCTAssertNil(op.filter {$0 == "other"})
        XCTAssertNotNil(op.filter {$0 == "some"})
        
        XCTAssertEqual(op.filter {$0 == "some"}, "some")
    }
}

#if os(Linux)
extension OptionalTests {
	static var allTests : [(String, (OptionalTests) -> () throws -> Void)] {
		return [
			("testGetOrElse", testGetOrElse),
			("testOrElse", testOrElse),
			("testFilter", testFilter),
		]
	}
}
#endif
