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

