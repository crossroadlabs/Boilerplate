//===--- Error.swift ------------------------------------------------------===//
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
import Result

public protocol RuntimeErrorType : Error, CustomStringConvertible {
    var customRepresentation:String {get}
}

public extension RuntimeErrorType {
    private func selfThrow() throws {
        throw self
    }
    
    func panic() -> Never  {
        try! selfThrow()
        while true {}
    }
    
    var stack:[String] {
        get {
            #if !os(Linux)
                #if swift(>=3.0)
                    return Foundation.Thread.callStackSymbols
                #else
                    return NSThread.callStackSymbols()
                #endif
            #else
                return ["Runtime error stack trace is not currently supported on Linux"]
            #endif
        }
    }
    
    var stackTrace:String {
        get {
            return "Stack trace: \(stack.description)"
        }
    }
    
    func formatDescription(_ custom:Any) -> String {
        return "\(custom)\n\(stackTrace)"
    }
    
    var customRepresentation:String {
        get {
            return "\(type(of: self))"
        }
    }
    
    var description:String {
        get {
            return formatDescription(customRepresentation)
        }
    }
}

public enum CommonRuntimeError : RuntimeErrorType {
    case notImplemented(what:String)
    case preconditionFailed(description:String)
    
    public var customRepresentation:String {
        get {
            switch self {
            case .notImplemented(let what):
                return "Not implemented: \(what)"
            case .preconditionFailed(let description):
                return "Precondition error: \(description)"
            }
        }
    }
}

public protocol AnyErrorProtocol : Error {
    init(_ error:Error)
    
    var error:Error {get}
}

extension AnyError : AnyErrorProtocol {
}

public protocol ErrorWithCodeType : Error {
    associatedtype Code
    
    init(code:Code)
    
    static func isError(_ code:Code) -> Bool
}

public enum CError : RuntimeErrorType {
    case unknown
    case code(code:Int32)
}

extension CError : ErrorWithCodeType {
    public typealias Code = Int32
    
    public init(code:Code) {
        self = .code(code: code)
    }
    
    public static func isError(_ code:Code) -> Bool {
        return code != 0
    }
}

public extension CError {
    public static let FAULT = EFAULT
    public static let INTR = EINTR
    public static let INVAL = EINVAL
}

public func ccall<Code, Error: ErrorWithCodeType>(_ fun:()->Code) -> Error? where Error.Code == Code {
    let result = fun()
    return Error.isError(result) ? Error(code: result) : nil
}

public func ccall<Code, Error: ErrorWithCodeType>(_: Error.Type = Error.self, fun:()->Code) throws where Error.Code == Code {
    if let error:Error = ccall(fun) {
        throw error
    }
}

public func ccall<Value, Code, Error: ErrorWithCodeType>(_ fun:(inout Code)->Value) -> Result<Value, Error> where Code : Zeroable, Error.Code == Code {
    var code:Code = .zero
    let result = fun(&code)
    if Error.isError(code) {
        return Result(error: Error(code: code))
    } else {
        return Result(value: result)
    }
}

public func ccall<Value, Code, Error: ErrorWithCodeType>(_: Error.Type = Error.self, fun:(inout Code)->Value) throws -> Value where Code : Zeroable, Error.Code == Code {
    let result:Result<Value, Error> = ccall(fun)
    return try result.dematerialize()
}
