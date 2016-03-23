//===--- String.swift ------------------------------------------------------===//
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
    public extension String {
        public func substring(from index: Index) -> String {
            return substringFromIndex(index)
        }
        
        public func substring(to index: Index) -> String {
            return substringToIndex(index)
        }
        
        public func substring(with range: Range<String.Index>) -> String {
            return substringWithRange(range)
        }
    }
    
    public extension String {
    
        /// Return `self` converted to lower case.
        ///
        /// - Complexity: O(n)
        public func lowercased() -> String {
            return lowercaseString
        }
    
        /// Return `self` converted to upper case.
        ///
        /// - Complexity: O(n)
        public func uppercased() -> String {
            return uppercaseString
        }
    
    }
    
#endif