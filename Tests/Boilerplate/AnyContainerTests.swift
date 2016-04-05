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
            let string = try container^!.substring(to: "string".startIndex.successor())
            XCTAssertEqual(string, "s")
        } catch {
            XCTFail("Can not throw really")
        }
        
        XCTAssertEqual((container^)!.substring(from: "string".startIndex.successor()), "tring")
        
        XCTAssertEqual((container^)!.substring(from: "string".startIndex.successor()), "tring")
        XCTAssertEqual(container^!!.substring(from: "string".startIndex.successor()), "tring")
        
        XCTAssertNotNil(container^)
        
        XCTAssertEqual(container^.map{$0.substring(to: "string".endIndex.predecessor())} ?? "wtf", "strin")
        
        XCTAssertEqual((container^)?.substring(from: "string".endIndex.predecessor()) ?? "wtf", "g")
        
        container^%.analysis(ifSuccess: { value -> Result<String, AnyError> in
            XCTAssertEqual("string", value)
            return Result<String, AnyError>(value: value)
        }, ifFailure: { error in
            XCTFail("Can not fail")
            return Result<String, AnyError>(error: error)
        })
    }
    
    func testContentMutation() {
        let container = MutableAnyContainer(Array<String>())
        
        XCTAssertEqual(container.content.count, 0)
        
        container.content.append("new")
        
        XCTAssertEqual(container.content.count, 1)
        
        container.content.removeAll()
        
        XCTAssertEqual(container.content.count, 0)
    }
}

#if os(Linux)
extension AnyContainerTests {
	static var allTests : [(String, AnyContainerTests -> () throws -> Void)] {
		return [
			("testInitAndGet", testInitAndGet),
			("testContentMutation", testContentMutation),
		]
	}
}
#endif