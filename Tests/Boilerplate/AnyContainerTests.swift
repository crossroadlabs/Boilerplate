//
//  AnyContainerTests.swift
//  Boilerplate
//
//  Created by Daniel Leping on 3/5/16.
//  Copyright © 2016 Crossroad Labs, LTD. All rights reserved.
//

import XCTest
import Foundation

@testable import Boilerplate

class AnyContainerTests: XCTestCase {
    
    func testInitAndGet() {
        let container = AnyContainer("string")
        
        XCTAssertEqual(container.content, "string")
//        XCTAssertEqual(container!!, "string")
    }
}
