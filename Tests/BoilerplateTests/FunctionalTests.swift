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

private class Decay {
    private let _e:XCTestExpectation
    
    init(e:XCTestExpectation) {
        _e = e
    }
    
    deinit {
        _e.fulfill()
    }
}

private extension Decay {
    func intToString(i:Int) -> String {
        return String(i)
    }
    
    func fullfill(e:XCTestExpectation) {
        e.fulfill()
    }
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
    
    func testWeakApply() {
        let e = self.expectation(description: "main")
        var decay:Decay! = Decay(e: e)
        
        let iToS = decay ~> Decay.intToString
        let ff = decay ~> Decay.fullfill
        
        ff(self.expectation(description: "inner"))
        
        
        let s1 = iToS(5)
        XCTAssertNotNil(s1)
        XCTAssertEqual("5", s1!)
        
        decay = nil
        
        self.waitForExpectations(timeout: 0, handler: nil)
        
        let s2 = iToS(6)
        XCTAssertNil(s2)
    }
    
    func testTupleFlatten() {
        let three = ((true, 1), 0.0)
        
        XCTAssertEqual("true_1_0.0", flatten(three) |> fthree)
    }
    
    func testTuplify() {
        let tthree = tuplify(fthree)
        let tuple = (false, 1, 0.0)
        
        XCTAssertEqual("false_1_0.0", tuple |> tthree)
        XCTAssertEqual("false_1_0.0", tthree(tuple))
    }
}
