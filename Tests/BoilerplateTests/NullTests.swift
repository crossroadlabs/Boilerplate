//
//  NullTests.swift
//  Boilerplate
//
//  Created by Daniel Leping on 17/06/2016.
//  Copyright © 2016 Crossroad Labs, LTD. All rights reserved.
//

import XCTest
import Foundation
import Result

import Boilerplate

enum Nullable {
    case yesnull
    case nonull
    case somemore
}

extension Nullable : NullEquatable {
}

func ==(lhs:Nullable, rhs:Null) -> Bool {
    switch lhs {
    case .yesnull:
        return true
    default:
        return false
    }
}

class NullTests: XCTestCase {
    let yesnull:Nullable? = .yesnull
    let nonull:Nullable? = .nonull
    let somemore:Nullable? = .somemore
    let actualnil:Nullable? = nil
    let snil:String? = nil
    let snnil:String? = ""
    
    func testNull() {
        XCTAssert(Nullable.yesnull == .null)
        XCTAssert(Nullable.yesnull == nil)
        
        XCTAssertFalse(Nullable.nonull == .null)
        XCTAssertFalse(Nullable.nonull == nil)
        XCTAssertFalse(Nullable.somemore == .null)
        XCTAssertFalse(Nullable.somemore == nil)
    }
    
    func testNotNull() {
        XCTAssertFalse(Nullable.yesnull != .null)
        XCTAssertFalse(Nullable.yesnull != nil)
        
        XCTAssert(Nullable.nonull != .null)
        XCTAssert(Nullable.nonull != nil)
        XCTAssert(Nullable.somemore != .null)
        XCTAssert(Nullable.somemore != nil)
    }
    
    func testOptional() {
        XCTAssert(snil == nil)
        XCTAssert(snil == .null)
        XCTAssert(snnil != nil)
        XCTAssert(snnil != .null)
        
        XCTAssertFalse(snil != nil)
        XCTAssertFalse(snil != .null)
        XCTAssertFalse(snnil == nil)
        XCTAssertFalse(snnil == .null)
    }
    
    func testOptionalNull() {
        XCTAssert(yesnull == .null)
        //XCTAssert(yesnull == nil)
        XCTAssert(actualnil == .null)
        //XCTAssert(actualnil == nil)
        
        XCTAssertFalse(nonull == .null)
        //XCTAssertFalse(nonull == nil)
        XCTAssertFalse(somemore == .null)
        //XCTAssertFalse(somemore == nil)
    }
    
    func testOptionalNotNull() {
        XCTAssertFalse(yesnull != .null)
        XCTAssertFalse(actualnil != .null)
        
        XCTAssert(nonull != .null)
        XCTAssert(somemore != .null)
    }
}

#if os(Linux)
extension NullTests {
	static var allTests : [(String, (NullTests) -> () throws -> Void)] {
		return [
			("testNull", testNull),
			("testNotNull", testNotNull),
			("testOptionalNull", testOptionalNull),
			("testOptionalNotNull", testOptionalNotNull),
		]
	}
}
#endif
