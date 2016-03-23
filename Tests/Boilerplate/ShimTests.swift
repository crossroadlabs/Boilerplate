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
}