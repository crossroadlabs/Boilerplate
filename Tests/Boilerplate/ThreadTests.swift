//
//  File.swift
//  Boilerplate
//
//  Created by Yegor Popovych on 3/24/16.
//  Copyright © 2016 Crossroad Labs, LTD. All rights reserved.
//

import XCTest
import Foundation
#if os(Linux)
    import Glibc
#endif

@testable import Boilerplate

class ThreadTests: XCTestCase {
    func testThreadRun() {
        var state = 0
        let _ = try! Thread {
            Thread.sleep(0.1)
            state = 1
            Thread.sleep(1)
            state = 2
        }
        XCTAssertEqual(state, 0)
        Thread.sleep(1)
        XCTAssertEqual(state, 1)
        Thread.sleep(2)
        XCTAssertEqual(state, 2)
    }
    
    func testJoin() {
        var state = 0
        let t = try! Thread {
            Thread.sleep(1)
            state = 1
        }
        try! t.join()
        XCTAssertEqual(state, 1)
    }
    
    func testSleep() {
        let before = time(nil)
        Thread.sleep(1)
        let after = time(nil)
        let diff = after - before
        print("Sleep time: \(diff)")
        XCTAssertLessThan(diff, 3)
        XCTAssertGreaterThan(diff, 0)
    }
    
    func testThreadLocal() {
        let local = try! ThreadLocal<Int8>()
        local.value = 1
        let _ = try! Thread {
            local.value = 2
        }
        let _ = try! Thread {
            local.value = 3
        }
        Thread.sleep(0.5)
        XCTAssertEqual(local.value, 1)
    }
    
    func testIsMain() {
        XCTAssert(Thread.isMain)
        let t = try! Thread {
            XCTAssert(!Thread.isMain)
        }
        XCTAssertNotEqual(Thread.current, t)
    }
}

#if os(Linux)
extension ThreadTests {
	static var allTests : [(String, ThreadTests -> () throws -> Void)] {
		return [
			("testThreadRun", testThreadRun),
			("testJoin", testJoin),
			("testSleep", testSleep),
			("testThreadLocal", testThreadLocal),
			("testIsMain", testIsMain),
		]
	}
}
#endif