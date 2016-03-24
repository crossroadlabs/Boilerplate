//===--- C.swift ------------------------------------------------------===//
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

#if swift(>=3.0)
#else
    public typealias OpaquePointer = COpaquePointer
    
    public extension OpaquePointer {
        public init<T>(bitPattern:Unmanaged<T>) {
            self = bitPattern.toOpaque()
        }
    }
    
    public extension UnsafeMutablePointer {
        public typealias Pointee = Memory
    
        /// Allocate and point at uninitialized aligned memory for `count`
        /// instances of `Pointee`.
        ///
        /// - Postcondition: The pointee is allocated, but not initialized.
        public init(allocatingCapacity count: Int) {
            self = UnsafeMutablePointer.alloc(count)
        }
        
        /// Deallocate uninitialized memory allocated for `count` instances
        /// of `Pointee`.
        ///
        /// - Precondition: The memory is not initialized.
        ///
        /// - Postcondition: The memory has been deallocated.
        public func deallocateCapacity(num: Int) {
            self.dealloc(num)
        }
        
        /// Access the `Pointee` instance referenced by `self`.
        ///
        /// - Precondition: the pointee has been initialized with an instance of
        ///   type `Pointee`.
        public var pointee: Pointee {
            get {
                return self.memory
            }
            nonmutating set {
                self.memory = newValue
            }
        }
        
        public func initialize(with newValue: Pointee, count: Int = 1) {
            assert(count != 1, "NOT IMPLEMENTED: currently can initialize with 1 value only")
            self.initialize(newValue)
        }
    
        /// De-initialize the `count` `Pointee`s starting at `self`, returning
        /// their memory to an uninitialized state.
        ///
        /// - Precondition: The `Pointee`s at `self..<self + count` are
        ///   initialized.
        ///
        /// - Postcondition: The memory is uninitialized.
        public func deinitialize(count count: Int = 1) {
            self.destroy(count)
        }
    }
#endif