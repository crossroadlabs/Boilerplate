//
//  TaskTests.swift
//  Boilerplate
//
//  Created by Daniel Leping on 24/09/2016.
//  Copyright © 2016 Crossroad Labs, LTD. All rights reserved.
//

import Foundation
import XCTest

import Result

import Boilerplate

class TaskTests: XCTestCase {
    private func nonescapingTaskCall(task:SafeTask) {
        task()
    }
    
    private func escapingTaskWrap(task:@escaping SafeTask) -> SafeTask {
        return {
            task()
        }
    }
    
    func testEscapingTasks() {
        let escapingExpectation = self.expectation(description: "Escaping")
        
        let task = escapingTaskWrap {
            escapingExpectation.fulfill()
        }
        
        task()
        
        self.waitForExpectations(timeout: 0, handler: nil)
    }
    
    func testNonEscapingTasks() {
        let nonescapingExpectation = self.expectation(description: "Non-Escaping")
        
        nonescapingTaskCall {
            nonescapingExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 0, handler: nil)
    }
}

#if os(Linux)
extension TaskTests {
	static var allTests : [(String, (TaskTests) -> () throws -> Void)] {
		return [
			("testEscapingTasks", testEscapingTasks),
			("testNonEscapingTasks", testNonEscapingTasks),
		]
	}
}
#endif