//
//  AnyContainerTests.swift
//  Boilerplate
//
//  Created by Daniel Leping on 3/5/16.
//  Copyright © 2016 Crossroad Labs, LTD. All rights reserved.
//

import XCTest
import Foundation
import Result

@testable import Boilerplate

class AnyContainerTests: XCTestCase {
    
    func testInitAndGet() {
        let container = AnyContainer("string")
        
        XCTAssertEqual(container.content, "string")
        do {
            let string = try container^.substringToIndex("string".startIndex.successor())
            XCTAssertEqual(string, "s")
        } catch {
            XCTFail("Can not throw really")
        }
        
        XCTAssertEqual(container^!.substringFromIndex("string".startIndex.successor()), "tring")
        
        XCTAssertNotNil(container^?)
        
        XCTAssertEqual(container^?.map{$0.substringToIndex("string".endIndex.predecessor())} ?? "wtf", "strin")
        
        container^%.analysis(ifSuccess: { value -> Result<String, AnyError> in
            XCTAssertEqual("string", value)
            return Result<String, AnyError>(value: value)
        }, ifFailure: { error in
            XCTFail("Can not fail")
            return Result<String, AnyError>(error: error)
        })
    }
}

#if os(Linux)
    extension AnyContainerTests : XCTestCaseProvider {
        var allTests : [(String, () throws -> Void)] {
            return [
                ("testInitAndGet", testInitAndGet),
            ]
        }
    }
#endif