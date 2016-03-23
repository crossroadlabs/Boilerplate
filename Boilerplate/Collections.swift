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

#if swift(>=3.0)
#else
    public typealias Collection = CollectionType
    public typealias Sequence = SequenceType
    public typealias IteratorProtocol = GeneratorType
    
    extension Sequence where Generator.Element == String {
        public func joined(separator separator: String) -> String {
            return self.joinWithSeparator(separator)
        }
    }
#endif

public protocol CopyableCollectionType : Collection {
    #if swift(>=3.0)
    init<C : Sequence where C.Iterator.Element == Iterator.Element>(_ s:C)
    #else
    init<C : Sequence where C.Generator.Element == Generator.Element>(_ s:C)
    #endif
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

public class ZippedSequence<A, B where A : IteratorProtocol, B : IteratorProtocol> : Sequence {
    #if swift(>=3.0)
    public typealias Iterator = AnyIterator<(A.Element, B.Element)>
    #else
    public typealias Generator = AnyGenerator<(A.Element, B.Element)>
    public typealias Iterator = Generator
    #endif
    
    var ag:A
    var bg:B
    
    public init(ag:A, bg:B) {
        self.ag = ag
        self.bg = bg
    }
    
    
    #if swift(>=3.0)
    #else
    public func generate() -> Generator {
        return makeIterator()
    }
    #endif
    
    public func makeIterator() -> Iterator {
        return Iterator {
            guard let a = self.ag.next() else {
                return nil
            }
            guard let b = self.bg.next() else {
                return nil
            }
            
            return (a, b)
        }
    }
}

#if swift(>=3.0)
    public extension Sequence {
        public func zip<T : Sequence>(other:T) -> ZippedSequence<Iterator, T.Iterator> {
            return ZippedSequence(ag: self.makeIterator(), bg: other.makeIterator())
        }
    }
#else
    public extension Sequence {
        public func zip<T : Sequence>(other:T) -> ZippedSequence<Generator, T.Generator> {
            return ZippedSequence(ag: self.generate(), bg: other.generate())
        }
    }
#endif