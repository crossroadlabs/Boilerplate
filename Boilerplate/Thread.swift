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

private func ThreadLocalDestructor(pointer:UnsafeMutablePointer<Void>) {
    if pointer != nil {
        Unmanaged<AnyObject>.fromOpaque(COpaquePointer(pointer)).release()
    }
}

public class ThreadLocal<T> {
    private let _key:pthread_key_t
    
    public init(value:T? = nil) throws {
        _key = pthread_key_t()
        try ccall(CError.self) {
            pthread_key_create(&_key, ThreadLocalDestructor)
        }
        
        if let value = value {
            self.value = value
        }
    }
    
    deinit {
        // Crash the whole damn thing. It's definately a programming error
        try! ccall(CError.self) {
            pthread_key_delete(_key)
        }
    }
    
    private func setValue(value:T?) throws {
        let unmanaged = value.map { Unmanaged.passRetained(AnyContainer($0)) }
        
        do {
            let pointer = unmanaged.map { unmanaged in
                UnsafeMutablePointer<Void>(unmanaged.toOpaque())
                }.getOrElse(nil)
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
            if pointer == nil {
                return nil
            }
            let container:AnyContainer<T> = Unmanaged.fromOpaque(COpaquePointer(pointer)).takeUnretainedValue()
            return container.content
        }
        set {
            // Yes, let it crash. Runtime error
            try! setValue(newValue)
        }
    }
}

private func thread_proc(arg: UnsafeMutablePointer<Void>) -> UnsafeMutablePointer<Void> {
    let task = Unmanaged<AnyContainer<SafeTask>>.fromOpaque(COpaquePointer(arg)).takeRetainedValue()
    task.content()
    return nil
}

private func detach_pthread(task:SafeTask) throws {
    var thread:pthread_t = pthread_t()
    let unmanaged = Unmanaged.passRetained(AnyContainer(task))
    let arg = UnsafeMutablePointer<Void>(unmanaged.toOpaque())
    do {
        try ccall(CError.self) {
            pthread_create(&thread, nil, thread_proc, arg)
        }
    } catch {
        unmanaged.release()
        throw error
    }
}

public class Thread {
    public let thread:pthread_t
    
    public init(pthread:pthread_t) {
        thread = pthread
    }
    
    public init(task:SafeTask) throws {
        self.thread = pthread_t()
        
        let unmanaged = Unmanaged.passRetained(AnyContainer(task))
        let arg = UnsafeMutablePointer<Void>(unmanaged.toOpaque())
        do {
            try ccall(CError.self) {
                pthread_create(&thread, nil, thread_proc, arg)
            }
        } catch {
            unmanaged.release()
            throw error
        }
    }
    
    public static func detach(task:SafeTask) throws {
        let _ = try Thread(task: task)
    }
    
    public static var isMain:Bool {
        get {
            #if os(Linux)
                return CFRunLoopGetMain() === CFRunLoopGetCurrent()
            #else
                return NSThread.isMainThread()
            #endif
        }
    }
    
    public static var current:Thread {
        get {
            return Thread(pthread: pthread_self())
        }
    }
}