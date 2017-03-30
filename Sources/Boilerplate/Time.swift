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

#if os(Linux)
    import Glibc
    public typealias time_spec = Glibc.timespec
#else
    import Darwin
    public typealias time_spec = Darwin.timespec
#endif

public enum Timeout {
    case Immediate
    case Infinity
    
    /// timeout in seconds. Can be less then 1
    case In(timeout:Double)
}


/// NSAdditions
public extension Timeout {
    public init(timeout:Double) {
        switch timeout {
        case let timeout where timeout <= 0:
            self = .Immediate
        case let timeout where timeout == Double.infinity:
            self = .Infinity
        default:
            self = .In(timeout: timeout)
        }
    }
    
    public init(until:Date) {
        self.init(timeout: until.timeIntervalSinceNow)
    }
    
    public var timeInterval:TimeInterval {
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
    
    public func time(since date:Date) -> Date {
        switch self {
        case .Immediate:
            return date
        case .Infinity:
            return Date.distantFuture
        case .In(let interval):
            return Date(timeInterval: interval, since: date)
        }
    }
    
    public func timeSinceNow() -> Date {
        switch self {
        case .Immediate:
            return Date()
        case .Infinity:
            return Date.distantFuture
        case .In(let interval):
            return Date(timeIntervalSinceNow: interval)
        }
    }
}

//Dispatch Additions
#if !nodispatch
    import Dispatch
    
    public extension Timeout {
        #if swift(>=3.0)
            /// Returns the `DispatchTime` representation of this interval
            public var dispatchTime: DispatchTime {
                switch self {
                case .Immediate:
                    return DispatchTime.now()
                case .Infinity:
                    return DispatchTime.distantFuture
                case .In(let interval):
                    let sec = Int(interval)
                    let nsec = Int((interval - Double(sec)) * Double(NSEC_PER_SEC))
                    let now = DispatchTime.now()
                    let secshifted = now + .seconds(sec)
                    let nsecshifted = secshifted + .nanoseconds(nsec)
                    return nsecshifted
                }
        }
        #else
            /// Returns the `dispatch_time_t` representation of this interval
            public var dispatchTime: dispatch_time_t {
                switch self {
                    case .Immediate:
                        return DISPATCH_TIME_NOW
                    case .Infinity:
                        return DISPATCH_TIME_FOREVER
                    case .In(let interval):
                        return dispatch_time(DISPATCH_TIME_NOW, Int64(interval * Double(NSEC_PER_SEC)))
                }
            }
        #endif
    }
#endif //!nodispatch

public extension Timeout {
    private static let NSEC_IN_SEC:Double = 1000 * 1000 * 1000
    
    public init(timespec:time_spec) {
        let timeout:Double = Double(timespec.tv_sec) + Double(timespec.tv_nsec) * Timeout.NSEC_IN_SEC
        self.init(timeout: timeout)
    }
    
    /// Returns the `timespec` representation of this interval
    public var timespec: time_spec {
        let interval = self.timeInterval
        let sec = time_t(interval)
        let nsec = Int((interval - Double(sec)) * Timeout.NSEC_IN_SEC)
        return time_spec(tv_sec:sec, tv_nsec: nsec)
    }
}

extension Timeout : ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(timeout: value)
    }
}

extension Timeout : ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .Immediate
    }
}

extension Timeout : ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(timeout: Double(value))
    }
}

public extension Timeout {
    public func toMillis() -> Double {
        switch self {
        case .Immediate:
            return 0
        case .Infinity:
            return Double.infinity
        case .In(timeout: let seconds):
            return seconds * 1000
        }
    }
}
