//
//  FunctionalTests.swift
//  Boilerplate
//
//  Created by Daniel Leping on 28/02/2017.
//  Copyright © 2017 Crossroad Labs, LTD. All rights reserved.
//

import Foundation
import XCTest

import Boilerplate

func fthree(b:Bool, i:Int, d:Double) -> String {
    return String(b) + "_" + String(i) + "_" + String(d)
}

class FunctionalTests: XCTestCase {
    //TODO: add more of test coverage
    func testApply() {
        let fbi = (__, __, 1.0) |> fthree
        let fi = (true, __, 1.0) |> fthree
        
        XCTAssertEqual(fbi(false, 0), "false_0_1.0")
        XCTAssertEqual(fi(0), "true_0_1.0")
        XCTAssertEqual((false, 0, 0.0) |> fthree, "false_0_0.0")
    }
    
    func testCurry() {
        let cthree = curry(fthree)
        let uthree = uncurry(cthree)
        let u2three:(Bool, Int, Double)->String = uncurry(cthree)
        
        XCTAssertEqual(cthree(false)(0)(1.0), "false_0_1.0")
        XCTAssertEqual(0.0 |> (false, 0) |> uthree, "false_0_0.0")
        XCTAssertEqual((false, 0, 0.0) |> u2three, "false_0_0.0")
    }
}
