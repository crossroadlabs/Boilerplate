//===--- Time.swift ------------------------------------------------------===//
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

public enum Timeout {
    case Immediate
    case Infinity
    
    /// timeout in seconds. Can be less then 1
    case In(timeout:Double)
}

/// NSAdditions
public extension Timeout {
    public var timeInterval:NSTimeInterval {
        get {
            switch self {
            case .Immediate:
                return 0
            case .Infinity:
                return Double.infinity
            case .In(let timeout):
                return timeout
            }
        }
    }
    
    public func timeSince(date:NSDate) -> NSDate {
        switch self {
        case .Immediate:
            return date
        case .Infinity:
            return NSDate.distantFuture()
        case .In(let interval):
            return NSDate(timeInterval: interval, sinceDate: date)
        }
    }
    
    public func timeSinceNow() -> NSDate {
        switch self {
        case .Immediate:
            return NSDate()
        case .Infinity:
            return NSDate.distantFuture()
        case .In(let interval):
            return NSDate(timeIntervalSinceNow: interval)
        }
    }
}