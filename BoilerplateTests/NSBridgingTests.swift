//
//  NSBridgingTests.swift
//  Boilerplate
//
//  Created by Daniel Leping on 3/5/16.
//  Copyright © 2016 Crossroad Labs, LTD. All rights reserved.
//

import XCTest
import Foundation

@testable import Boilerplate

class NSBridgingTests: XCTestCase {
    
    func testStringBridging() {
        XCTAssert("mystring".ns.dynamicType.isSubclassOfClass(NSString.self))
    }
    
    func testArrayBridging() {
        XCTAssertTrue(["element"].ns.dynamicType.isSubclassOfClass(NSArray.self))
    }
    
    func testDictionaryBridging() {
        XCTAssertTrue(["key": "value"].ns.dynamicType.isSubclassOfClass(NSDictionary.self))
    }
}