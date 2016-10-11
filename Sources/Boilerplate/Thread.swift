//===--- Thread.swift ------------------------------------------------------===//
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
import CoreFoundation

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

#if os(Linux)
    private func ThreadLocalDestructor(pointer:UnsafeMutableRawPointer?) {
        if pointer != .null {
            Unmanaged<AnyObject>.fromOpaque(pointer!).release()
        }
    }
#else
    private func ThreadLocalDestructor(pointer:UnsafeMutableRawPointer) {
        if pointer != .null {
            Unmanaged<AnyObject>.fromOpaque(pointer).release()
        }
    }
#endif

public class ThreadLocal<T> {
    private let _key:pthread_key_t
    
    public init(value:T? = nil) throws {
        var key = pthread_key_t()
        
        try ccall(CError.self) {
            pthread_key_create(&key, ThreadLocalDestructor)
        }
        
        _key = key
        
        if let value = value {
            try setValue(value)
        }
    }
    
    deinit {
        // Crash the whole damn thing. It's definately a programming error
        try! ccall(CError.self) {
            pthread_key_delete(_key)
        }
    }
    
    private func setValue(_ value:T?) throws {
        let unmanaged = value.map { Unmanaged.passRetained(AnyContainer($0)) }
        
        do {
            let pointer = unmanaged.map { unmanaged in
                UnsafeMutableRawPointer(unmanaged.toOpaque())
            }.getOr(else: nil)
            try ccall(CError.self) {
                pthread_setspecific(_key, pointer)
            }
        } catch {
            unmanaged?.release()
            throw error
        }
    }
    
    public var value:T? {
        get {
            let pointer = pthread_getspecific(_key)
            if pointer == .null {
                return nil
            }
            let container:AnyContainer<T> = Unmanaged.fromOpaque(pointer!).takeUnretainedValue()
            return container.content
        }
        set {
            // Yes, let it crash. Runtime error
            try! setValue(newValue)
        }
    }
}


#if os(Linux)
    private func thread_proc(arg: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
        let task = Unmanaged<AnyContainer<SafeTask>>.fromOpaque(arg!).takeRetainedValue()
        task.content()
        return nil
    }
#else
    private func thread_proc(arg: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
        let task = Unmanaged<AnyContainer<SafeTask>>.fromOpaque(arg).takeRetainedValue()
        task.content()
        return nil
    }
#endif

public class Thread : Equatable {
    public let thread:pthread_t!
    
    public init(pthread:pthread_t) {
        thread = pthread
    }
    
    public init(task:SafeTask) throws {
        let unmanaged = Unmanaged.passRetained(AnyContainer(task))
        let arg = UnsafeMutableRawPointer(unmanaged.toOpaque())
        do {
            self.thread = try ccall(CError.self) { code in
                #if os(Linux)
                    var thread:pthread_t = 0
                #else
                    var thread:pthread_t? = nil
                #endif
                code = pthread_create(&thread, nil, thread_proc, arg)
                return thread
            }
        } catch {
            unmanaged.release()
            throw error
        }
    }
    
    private func _join() throws -> UnsafeMutableRawPointer! {
        #if swift(>=3.0)
            var result:UnsafeMutableRawPointer? = nil
        #else
            var result:UnsafeMutablePointer<Void> = nil
        #endif
        try ccall(CError.self) {
            pthread_join(thread, &result)
        }
        return result
    }
    
    #if swift(>=3.0)
        @discardableResult public func join() throws -> UnsafeMutableRawPointer! {
            return try _join()
        }
    #else
        public func join() throws -> UnsafeMutableRawPointer! {
            return try _join()
        }
    #endif
    
    public static func detach(task:SafeTask) throws {
        let _ = try Thread(task: task)
    }
    
    public static var isMain:Bool {
        get {
            #if os(Linux)
                return CFRunLoopGetMain() === CFRunLoopGetCurrent()
            #else
                return pthread_main_np() != 0
            #endif
        }
    }
    
    public static var current:Thread {
        get {
            return Thread(pthread: pthread_self())
        }
    }
    
    private static func _sleep(timeout:Timeout) -> Timeout? {
        var time = timeout.timespec
        return try! ccall(CError.self) { code in
            var rem:timespec = timespec()
            let ret = nanosleep(&time, &rem)
            if ret == CError.INTR {
                return Timeout(timespec: rem)
            } else {
                code = ret
                return nil
            }
        }
    }
    
    #if swift(>=3.0)
        @discardableResult public static func sleep(timeout:Timeout) -> Timeout? {
            return _sleep(timeout: timeout)
        }
    #else
        public static func sleep(timeout timeout:Timeout) -> Timeout? {
            return _sleep(timeout)
        }
    #endif
}

public func ==(lhs:Thread, rhs:Thread) -> Bool {
    return pthread_equal(lhs.thread, rhs.thread) != 0
}
