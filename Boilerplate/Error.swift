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

public protocol AnyErrorType : ErrorType {
    init(_ error:ErrorType)
    
    var error:ErrorType {get}
}

public struct AnyError : AnyErrorType {
    public let error:ErrorType
    
    public init(_ error:ErrorType) {
        self.error = error
    }
}

public protocol ErrorWithCodeType : ErrorType {
    init(code:Int32)
    
    static func isError(code:Int32) -> Bool
}

public enum CError : ErrorType {
    case Unknown
    case Code(code:Int32)
}

extension CError : ErrorWithCodeType {
    public init(code:Int32) {
        self = .Code(code: code)
    }
    
    public static func isError(code:Int32) -> Bool {
        return code != 0
    }
}

public func ccall<Error: ErrorWithCodeType>(@noescape fun:()->Int32) -> Error? {
    let result = fun()
    return Error.isError(result) ? Error(code: result) : nil
}

public func ccall<Error: ErrorWithCodeType>(_: Error.Type, @noescape fun:()->Int32) throws {
    if let error:Error = ccall(fun) {
        throw error
    }
}

public func ccall<Value, Error: ErrorWithCodeType>(@noescape fun:(inout code:Int32)->Value) -> Result<Value, Error> {
    var code:Int32 = 0
    let result = fun(code: &code)
    if Error.isError(code) {
        return Result(error: Error(code: code))
    } else {
        return Result(value: result)
    }
}

public func ccall<Value, Error: ErrorWithCodeType>(_: Error.Type, @noescape fun:(inout code:Int32)->Value) throws -> Value {
    let result:Result<Value, Error> = ccall(fun)
    return try result.dematerialize()
}