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
    let _string = "string"
    
    
    func testInitAndGet() {
        let container = AnyContainer(_string)
        
        XCTAssertEqual(container.content, _string)
        do {
            let string = try container^!.substring(to: _string.index(after: _string.startIndex))
            XCTAssertEqual(string, "s")
        } catch {
            XCTFail("Can not throw really")
        }
        
        XCTAssertEqual((container^)!.substring(from: _string.index(after: _string.startIndex)), "tring")
        
        XCTAssertEqual((container^)!.substring(from: _string.index(after: _string.startIndex)), "tring")
        XCTAssertEqual(container^!!.substring(from: _string.index(after: _string.startIndex)), "tring")
        
        XCTAssertNotNil(container^)
        
        XCTAssertEqual(container^.map{$0.substring(to: _string.index(before: _string.endIndex))} ?? "wtf", "strin")
        
        XCTAssertEqual((container^)?.substring(from: _string.index(before: _string.endIndex)) ?? "wtf", "g")
        
        let _ = container^%.analysis(ifSuccess: { value -> Result<String, AnyError> in
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
	static var allTests : [(String, (AnyContainerTests) -> () throws -> Void)] {
		return [
			("testInitAndGet", testInitAndGet),
			("testContentMutation", testContentMutation),
		]
	}
}
#endif
