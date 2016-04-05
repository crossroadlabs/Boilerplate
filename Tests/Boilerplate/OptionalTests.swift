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
        
        XCTAssertEqual(existingString.getOrElse("else"), "exists")
        
        let nilString:String? = nil
        
        XCTAssertNil(nilString)
        
        XCTAssertEqual(nilString.getOrElse("else"), "else")
        
        let noAutoclosure = nilString.getOrElse {
            "else"
        }
        
        XCTAssertEqual(noAutoclosure, "else")
    }
    
    func testOrElse() {
        let existingString:String? = "exists"
        
        XCTAssertNotNil(existingString)
        XCTAssertNotNil(existingString.orElse(nil))
        
        let nilString:String? = nil
        
        XCTAssertNil(nilString)
        XCTAssertNil(nilString.orElse(nil))
        XCTAssertNotNil(nilString.orElse(existingString))
        
        let noAutoclosureNil = nilString.orElse {
            nil
        }
        
        XCTAssertNil(noAutoclosureNil)
        
        let noAutoclosure = nilString.orElse {
            existingString
        }
        
        XCTAssertNotNil(noAutoclosure)
    }
}

#if os(Linux)
extension OptionalTests {
	static var allTests : [(String, OptionalTests -> () throws -> Void)] {
		return [
			("testGetOrElse", testGetOrElse),
			("testOrElse", testOrElse),
		]
	}
}
#endif