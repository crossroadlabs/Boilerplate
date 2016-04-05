//
//  ContainerTests.swift
//  Boilerplate
//
//  Created by Daniel Leping on 3/5/16.
//  Copyright © 2016 Crossroad Labs, LTD. All rights reserved.
//

import XCTest
import Foundation
import Result

@testable import Boilerplate

enum MockError : ErrorProtocol {
    case Error1
    case Error2
}

class CantainerWithParticularError<V, E: ErrorProtocol> : ContainerWithErrorType {
    typealias Value = V
    typealias Error = E
    
    let error:Error
    
    init(_ content: V, error: E) {
        self.error = error
    }
    
    func withdrawResult() -> Result<V, Error> {
        return Result(error: error)
    }
}

class CantainerWithAnyError<V> : ContainerWithErrorType {
    typealias Value = V
    typealias Error = AnyError
    
    init(_ content: V) {
    }
    
    func withdrawResult() -> Result<V, Error> {
        return Result(error: MockError.Error1)
    }
}

class ContainerTests: XCTestCase {
    
    func testParticularError() {
        let container = CantainerWithParticularError("string", error: MockError.Error1)
        
        do {
            try container^!
            XCTFail("Must have thrown")
        } catch let e {
            switch e {
            case MockError.Error1:
                break
            default:
                XCTFail("Wrong error thrown")
            }
        }
        
        XCTAssertNil(container^)
        
        container^%.analysis(ifSuccess: { value -> Result<String, MockError> in
            XCTFail("Can not be with success")
            return Result<String, MockError>(value: value)
        }, ifFailure: { error in
            XCTAssertEqual(error, MockError.Error1)
            return Result<String, MockError>(error: error)
        })
    }
    
    func testAnyError() {
        let container = CantainerWithAnyError("string")
        
        do {
            try container^!
            XCTFail("Must have thrown")
        } catch let e {
            switch e {
            case MockError.Error1:
                break
            default:
                XCTFail("Wrong error thrown")
            }
        }
        
        XCTAssertNil(container^)
        
        container^%.analysis(ifSuccess: { value -> Result<String, AnyError> in
            XCTFail("Can not be with success")
            return Result<String, AnyError>(value: value)
        }, ifFailure: { error in
            switch error.error {
            case MockError.Error1:
                break
            default:
                XCTFail("Wrong error thrown")
            }
            return Result<String, AnyError>(error: error)
        })
    }
}

#if os(Linux)
extension ContainerTests {
	static var allTests : [(String, ContainerTests -> () throws -> Void)] {
		return [
			("testParticularError", testParticularError),
			("testAnyError", testAnyError),
		]
	}
}
#endif