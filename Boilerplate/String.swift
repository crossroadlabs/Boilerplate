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
    
    //use using older version compatibility because of Swift 2.2 naming limitations
    public extension String {
        public func substringFromIndex(index: Index) -> String {
            return substring(from: index)
        }
        
        public func substringToIndex(index: Index) -> String {
            return substring(to: index)
        }
        
        public func substringWithRange(range: Range<String.Index>) -> String {
            return substring(with: range)
        }
    }
    
#endif