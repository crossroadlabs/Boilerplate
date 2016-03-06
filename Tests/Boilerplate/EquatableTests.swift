//
//  EquatableTests.swift
//  Boilerplate
//
//  Created by Daniel Leping on 3/6/16.
//  Copyright © 2016 Crossroad Labs, LTD. All rights reserved.
//

import XCTest
import Foundation
import Result

@testable import Boilerplate

private struct NonStrictEquatableMock : NonStrictEquatable, Equatable {
    private let val:String
    
    init(_ val:String) {
        self.val = val
    }
    
    func isEqualTo(other: NonStrictEquatable) -> Bool {
        return (other as? NonStrictEquatableMock)?.val == self.val
    }
}

class EquatableTests: XCTestCase {
    func testNonStrictEquatable() {
        let same1 = NonStrictEquatableMock("same")
        let same2 = NonStrictEquatableMock("same")
        let other = NonStrictEquatableMock("other")
        
        XCTAssertEqual(same1, same2)
        XCTAssertNotEqual(same1, other)
        
        XCTAssertFalse(same1 == other)
        XCTAssertTrue(same1 == same2)
        XCTAssertTrue(same1 != other)
        XCTAssertFalse(same1 != same2)
        
        let array1:Array<NonStrictEquatable> = [same1]
        let array2:Array<NonStrictEquatable> = [same2]
        let array3:Array<NonStrictEquatable> = [other]
        
        XCTAssert(array1 == array2)
        XCTAssert(array1 != array3)
        XCTAssertFalse(array3 == array2)
        XCTAssert(array3 != array1)
        XCTAssertFalse(array1 != array2)
    }
}

#if os(Linux)
    extension EquatableTests : XCTestCaseProvider {
        var allTests : [(String, () throws -> Void)] {
            return [
                ("testNonStrictEquatable", testNonStrictEquatable),
            ]
        }
    }
#endif
