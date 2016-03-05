//===--- NSBridging.swift ------------------------------------------------------===//
//Copyright (c) 2016 Daniel Leping (dileping)
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.
//===----------------------------------------------------------------------===//

import Foundation

public protocol NSBridging {
    typealias NSBridgeTo : NSObject
}

public extension NSBridging {
    private func bridge() -> NSBridgeTo {
        return self as! AnyObject as! NSBridgeTo
    }
    
    public var ns:NSBridgeTo {
        get {
            return self.bridge()
        }
    }
}

extension String : NSBridging {
    public typealias NSBridgeTo = NSString
}

extension Array : NSBridging {
    public typealias NSBridgeTo = NSArray
}

extension Dictionary : NSBridging {
    public typealias NSBridgeTo = NSDictionary
}

public func isNoBridge<NSType : NSObject>(any:Any, type:NSType.Type) -> Bool {
    #if os(Linux)
        return any is NSType
    #else
        let anyType = any.dynamicType
        switch anyType {
        case let anyClass as AnyClass: return anyClass.isSubclassOfClass(type)
        default: return false
        }
    #endif
}

public func asNoBridge<NSType : NSObject>(any:Any, type:NSType.Type) -> NSType? {
    if isNoBridge(any, type: type) {
        return (any as? AnyObject).flatMap{$0 as? NSType}
    } else {
        return nil
    }
}

public func asNoBridge<NSType : NSObject>(any:Any) -> NSType? {
    return asNoBridge(any, type: NSType.self)
}