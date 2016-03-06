//===--- Collections.swift ------------------------------------------------------===//
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

public protocol CopyableCollectionType : CollectionType {
    init<C : SequenceType where C.Generator.Element == Generator.Element>(_ s:C)
}

extension Array : CopyableCollectionType {
}

extension Set : CopyableCollectionType {
}

public extension CopyableCollectionType {
    public typealias EnumeratorCallback = (Generator.Element) -> Void
    public typealias Enumerator = (EnumeratorCallback) -> Void
    
    public init(enumerator:Enumerator) {
        var array = Array<Generator.Element>()
        enumerator { element in
            array.append(element)
        }
        self.init(array)
    }
}

public extension SequenceType {
    public func zip<T : SequenceType>(other:T) -> Array<(Generator.Element, T.Generator.Element)> {
        var selfGenerator = self.generate()
        var otherGenerator = other.generate()
        
        //TODO: reimplement with autogenerating sequence. Will work for now though
        var result = Array<(Generator.Element, T.Generator.Element)>()
        
        while true {
            guard let s = selfGenerator.next() else {
                break
            }
            guard let o = otherGenerator.next() else {
                break
            }
            
            result.append((s, o))
        }
        
        return result
    }
}