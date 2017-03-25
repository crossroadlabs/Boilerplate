//===--- Tuple.swift ------------------------------------------------------===//
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

//======================================= TUPLE =======================================

public protocol Tuple {
    associatedtype Wrapped
    
    init(tuple: Wrapped)
    init(array: [Any?])
    
    var tuple: Wrapped {get}
    var stripe:[Any] {get}
}

public typealias TupleProtocol = Tuple

//======================================= TUPLE1 =======================================

public protocol Tuple1Protocol : Tuple {
    associatedtype A
}

public struct Tuple1<AI> : Tuple1Protocol {
    public typealias A = AI
    public typealias Wrapped = (A)
    
    public let tuple: Wrapped
    
    public init(tuple: Wrapped) {
        self.tuple = tuple
    }
    
    public init(_ a: A) {
        self.init(tuple: (a))
    }
    
    public init(array: [Any?]) {
        self.init(array.first! as! A)
    }
    
    public var stripe:[Any] {
        return [tuple]
    }
}

//======================================= TUPLE2 =======================================

public protocol Tuple2Protocol : Tuple {
    associatedtype A
    associatedtype B
}

public struct Tuple2<AI, BI> : Tuple2Protocol {
    public typealias A = AI
    public typealias B = BI
    public typealias Wrapped = (A, B)
    
    public let tuple: Wrapped
    
    public init(tuple: Wrapped) {
        self.tuple = tuple
    }
    
    public init(_ a: A, _ b: B) {
        self.init(tuple: (a, b))
    }
    
    public init(array: [Any?]) {
        self.init(array[0] as! A, array[1] as! B)
    }
    
    public var stripe:[Any] {
        return [tuple.0, tuple.1]
    }
}

//======================================= TUPLE3 =======================================

public struct Tuple3<A, B, C> : Tuple {
    public typealias Wrapped = (A, B, C)
    
    public let tuple: Wrapped
    
    public init(tuple: Wrapped) {
        self.tuple = tuple
    }
    
    public init(_ a: A, _ b: B, _ c: C) {
        self.init(tuple: (a, b, c))
    }
    
    public init(array: [Any?]) {
        self.init(array[0] as! A, array[1] as! B, array[2] as! C)
    }
    
    public var stripe:[Any] {
        return [tuple.0, tuple.1, tuple.2]
    }
}

//======================================= TUPLE4 =======================================

public struct Tuple4<A, B, C, D> : Tuple {
    public typealias Wrapped = (A, B, C, D)
    
    public let tuple: Wrapped
    
    public init(tuple: Wrapped) {
        self.tuple = tuple
    }
    
    public init(_ a: A, _ b: B, _ c: C, _ d: D) {
        self.init(tuple: (a, b, c, d))
    }
    
    public init(array: [Any?]) {
        self.init(array[0] as! A, array[1] as! B, array[2] as! C, array[3] as! D)
    }
    
    public var stripe:[Any] {
        return [tuple.0, tuple.1, tuple.2, tuple.3]
    }
}

//======================================= TUPLE5 =======================================

public struct Tuple5<A, B, C, D, E> : Tuple {
    public typealias Wrapped = (A, B, C, D, E)
    
    public let tuple: Wrapped
    
    public init(tuple: Wrapped) {
        self.tuple = tuple
    }
    
    public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) {
        self.init(tuple: (a, b, c, d, e))
    }
    
    public init(array: [Any?]) {
        self.init(array[0] as! A, array[1] as! B, array[2] as! C, array[3] as! D, array[4] as! E)
    }
    
    public var stripe:[Any] {
        return [tuple.0, tuple.1, tuple.2, tuple.3, tuple.4]
    }
}

//======================================= TUPLE6 =======================================

public struct Tuple6<A, B, C, D, E, F> : Tuple {
    public typealias Wrapped = (A, B, C, D, E, F)
    
    public let tuple: Wrapped
    
    public init(tuple: Wrapped) {
        self.tuple = tuple
    }
    
    public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F) {
        self.init(tuple: (a, b, c, d, e, f))
    }
    
    public init(array: [Any?]) {
        self.init(array[0] as! A, array[1] as! B, array[2] as! C, array[3] as! D, array[4] as! E, array[5] as! F)
    }
    
    public var stripe:[Any] {
        return [tuple.0, tuple.1, tuple.2, tuple.3, tuple.4, tuple.5]
    }
}

//======================================= TUPLE7 =======================================

public struct Tuple7<A, B, C, D, E, F, G> : Tuple {
    public typealias Wrapped = (A, B, C, D, E, F, G)
    
    public let tuple: Wrapped
    
    public init(tuple: Wrapped) {
        self.tuple = tuple
    }
    
    public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G) {
        self.init(tuple: (a, b, c, d, e, f, g))
    }
    
    public init(array: [Any?]) {
        self.init(array[0] as! A,
                  array[1] as! B,
                  array[2] as! C,
                  array[3] as! D,
                  array[4] as! E,
                  array[5] as! F,
                  array[6] as! G)
    }
    
    public var stripe:[Any] {
        return [tuple.0, tuple.1, tuple.2, tuple.3, tuple.4, tuple.5, tuple.6]
    }
}

//======================================= TUPLE8 =======================================

public struct Tuple8<A, B, C, D, E, F, G, H> : Tuple {
    public typealias Wrapped = (A, B, C, D, E, F, G, H)
    
    public let tuple: Wrapped
    
    public init(tuple: Wrapped) {
        self.tuple = tuple
    }
    
    public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H) {
        self.init(tuple: (a, b, c, d, e, f, g, h))
    }
    
    public init(array: [Any?]) {
        self.init(array[0] as! A,
                  array[1] as! B,
                  array[2] as! C,
                  array[3] as! D,
                  array[4] as! E,
                  array[5] as! F,
                  array[6] as! G,
                  array[7] as! H)
    }
    
    public var stripe:[Any] {
        return [tuple.0, tuple.1, tuple.2, tuple.3, tuple.4, tuple.5, tuple.6, tuple.7]
    }
}

//======================================= TUPLE9 =======================================

public struct Tuple9<A, B, C, D, E, F, G, H, I> : Tuple {
    public typealias Wrapped = (A, B, C, D, E, F, G, H, I)
    
    public let tuple: Wrapped
    
    public init(tuple: Wrapped) {
        self.tuple = tuple
    }
    
    public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H, _ i: I) {
        self.init(tuple: (a, b, c, d, e, f, g, h, i))
    }
    
    public init(array: [Any?]) {
        self.init(array[0] as! A,
                  array[1] as! B,
                  array[2] as! C,
                  array[3] as! D,
                  array[4] as! E,
                  array[5] as! F,
                  array[6] as! G,
                  array[7] as! H,
                  array[8] as! I)
    }
    
    public var stripe:[Any] {
        return [tuple.0, tuple.1, tuple.2, tuple.3, tuple.4, tuple.5, tuple.6, tuple.7, tuple.8]
    }
}

//======================================= TUPLE10 =======================================

public struct Tuple10<A, B, C, D, E, F, G, H, I, J> : Tuple {
    public typealias Wrapped = (A, B, C, D, E, F, G, H, I, J)
    
    public let tuple: Wrapped
    
    public init(tuple: Wrapped) {
        self.tuple = tuple
    }
    
    public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G, _ h: H, _ i: I, _ j: J) {
        self.init(tuple: (a, b, c, d, e, f, g, h, i, j))
    }
    
    public init(array: [Any?]) {
        self.init(array[0] as! A,
                  array[1] as! B,
                  array[2] as! C,
                  array[3] as! D,
                  array[4] as! E,
                  array[5] as! F,
                  array[6] as! G,
                  array[7] as! H,
                  array[8] as! I,
                  array[9] as! J)
    }
    
    public var stripe:[Any] {
        return [tuple.0, tuple.1, tuple.2, tuple.3, tuple.4, tuple.5, tuple.6, tuple.7, tuple.8, tuple.9]
    }
}

//======================================= CASE =======================================

public protocol CaseProtocol {
    associatedtype Tuple : TupleProtocol
    
    init(tuple: Tuple.Wrapped)
    
    var tuple: Self.Tuple.Wrapped {get}
}

public extension CaseProtocol {
    public init(tuple: Tuple) {
        self.init(tuple: tuple.tuple)
    }
    
    public var tuple: Self.Tuple {
        return Self.Tuple(tuple: tuple)
    }
}


//======================================= FLATTEN =======================================

//THREE
public func flatten<A, B, C>(_ t:((A, B), C)) -> (A, B, C) {
    return (t.0.0, t.0.1, t.1)
}

public func flatten<A, B, C>(_ t:(A, (B, C))) -> (A, B, C) {
    return (t.0, t.1.0, t.1.1)
}

//FOUR... I'm already crying
public func flatten<A, B, C, D>(_ t:((A, B), C, D)) -> (A, B, C, D) {
    return (t.0.0, t.0.1, t.1, t.2)
}

public func flatten<A, B, C, D>(_ t:(A, (B, C), D)) -> (A, B, C, D) {
    return (t.0, t.1.0, t.1.1, t.2)
}

public func flatten<A, B, C, D>(_ t:(A, B, (C, D))) -> (A, B, C, D) {
    return (t.0, t.1, t.2.0, t.2.1)
}

public func flatten<A, B, C, D>(_ t:((A, B), (C, D))) -> (A, B, C, D) {
    return (t.0.0, t.0.1, t.1.0, t.1.1)
}

public func flatten<A, B, C, D>(_ t:((A, B, C), D)) -> (A, B, C, D) {
    return (t.0.0, t.0.1, t.0.2, t.1)
}

public func flatten<A, B, C, D>(_ t:(A, (B, C, D))) -> (A, B, C, D) {
    return (t.0, t.1.0, t.1.1, t.1.2)
}

//======================================= TUPLIFY =======================================

public func tuplify<A, Z>(_ f:@escaping (A)->Z) -> ((A))->Z { return { tuple in f(tuple) } }
public func tuplify<A, B, Z>(_ f:@escaping (A, B)->Z) -> ((A, B))->Z { return { $0 |> f} }
public func tuplify<A, B, C, Z>(_ f:@escaping (A, B, C)->Z) -> ((A, B, C))->Z { return { $0 |> f} }
public func tuplify<A, B, C, D, Z>(_ f:@escaping (A, B, C, D)->Z) -> ((A, B, C, D))->Z { return { $0 |> f} }

