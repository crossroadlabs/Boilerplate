//
//  SignatureTests.swift
//  Boilerplate
//
//  Created by Daniel Leping on 02/12/2016.
//  Copyright © 2016 Crossroad Labs, LTD. All rights reserved.
//

import Foundation
import XCTest

import Boilerplate

private class Dummy : SignatureProvider {
}

class SignatureTests: XCTestCase {
    func testSignature() {
        let a = Dummy()
        let b = Dummy()
        
        XCTAssertEqual(a.signature, a.signature)
        XCTAssertEqual(b.signature, b.signature)
        
        XCTAssertNotEqual(a.signature, b.signature)
    }
    
    func testSignatureUniqueness() {
        let count = 10000000
        
        var set:Set<Int> = []
        var objects = Array<Dummy>()
        objects.reserveCapacity(count)
        
        for _ in 0..<count {
            let dummy = Dummy()
            objects.append(dummy)
            
            set.insert(dummy.signature)
        }
        
        XCTAssertEqual(count, set.count)
    }
}
