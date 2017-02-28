//===--- Apply.swift ------------------------------------------------------===//
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

infix operator |> : AssignmentPrecedence

//Single
public func apply<A,Z>(args:(A), to f:(A)->Z) -> Z {
    return f(args)
}

public func |><A,Z>(args:(A), f:(A)->Z) -> Z {
    return apply(args: args, to: f)
}

public func apply<A,Z>(args:(Void), to f:@escaping (A)->Z) -> (A) -> Z {
    return f
}

public func |><A,Z>(args:(Void), f:@escaping (A)->Z) -> (A) -> Z {
    return apply(args: args, to: f)
}

//Two
public func apply<A,B,Z>(args:(A, B), to f:(A, B)->Z) -> Z {
    return f(args.0, args.1)
}

public func |><A,B,Z>(args:(A, B), f:(A, B)->Z) -> Z {
    return apply(args: args, to: f)
}

public func apply<A,B,Z>(args:(Void, B), to f:@escaping (A, B)->Z) -> (A) -> Z {
    return { a in
        return f(a, args.1)
    }
}

public func |><A,B,Z>(args:(Void, B), f:@escaping (A, B)->Z) -> (A) -> Z {
    return apply(args: args, to: f)
}

public func apply<A,B,Z>(args:(A, Void), to f:@escaping (A, B)->Z) -> (B) -> Z {
    return { b in
        return f(args.0, b)
    }
}

public func |><A,B,Z>(args:(A, Void), f:@escaping (A, B)->Z) -> (B) -> Z {
    return apply(args: args, to: f)
}

//Three
public func apply<A,B,C,Z>(args:(A, B, C), to f:(A, B, C)->Z) -> Z {
    return f(args.0, args.1, args.2)
}

public func |><A,B,C,Z>(args:(A, B, C), f:(A, B, C)->Z) -> Z {
    return apply(args: args, to: f)
}

public func apply<A,B,C,Z>(args:(Void, B, C), to f:@escaping (A, B, C)->Z) -> (A)->Z {
    return { a in
        return f(a, args.1, args.2)
    }
}

public func |><A,B,C,Z>(args:(Void, B, C), f:@escaping (A, B, C)->Z) -> (A)->Z {
    return apply(args: args, to: f)
}

public func apply<A,B,C,Z>(args:(A, Void, C), to f:@escaping (A, B, C)->Z) -> (B)->Z {
    return { b in
        return f(args.0, b, args.2)
    }
}

public func |><A,B,C,Z>(args:(A, Void, C), f:@escaping (A, B, C)->Z) -> (B)->Z {
    return apply(args: args, to: f)
}

public func apply<A,B,C,Z>(args:(A, B, Void), to f:@escaping (A, B, C)->Z) -> (C)->Z {
    return { c in
        return f(args.0, args.1, c)
    }
}

public func |><A,B,C,Z>(args:(A, B, Void), f:@escaping (A, B, C)->Z) -> (C)->Z {
    return apply(args: args, to: f)
}

public func apply<A,B,C,Z>(args:(Void, Void, C), to f:@escaping (A, B, C)->Z) -> (A, B)->Z {
    return { a, b in
        return f(a, b, args.2)
    }
}

public func |><A,B,C,Z>(args:(Void, Void, C), f:@escaping (A, B, C)->Z) -> (A, B)->Z {
    return apply(args: args, to: f)
}

public func apply<A,B,C,Z>(args:(Void, B, Void), to f:@escaping (A, B, C)->Z) -> (A, C)->Z {
    return { a, c in
        return f(a, args.1, c)
    }
}

public func |><A,B,C,Z>(args:(Void, B, Void), f:@escaping (A, B, C)->Z) -> (A, C)->Z {
    return apply(args: args, to: f)
}

public func apply<A,B,C,Z>(args:(A, Void, Void), to f:@escaping (A, B, C)->Z) -> (B, C)->Z {
    return { b, c in
        return f(args.0, b, c)
    }
}

public func |><A,B,C,Z>(args:(A, Void, Void), f:@escaping (A, B, C)->Z) -> (B, C)->Z {
    return apply(args: args, to: f)
}

//WEAK
public func weakapply<T : AnyObject, A>(arg:T, to f:@escaping (T)->(A)->()) -> (A)->() {
    weak var arg = arg
    return { a in
        if let arg = arg {
            f(arg)(a)
        }
    }
}

public func ~><T : AnyObject, A>(arg:T, f:@escaping (T)->(A)->()) -> (A)->() {
    return weakapply(arg: arg, to: f)
}

public func weakapply<T : AnyObject, A, Z>(arg:T, to f:@escaping (T)->(A)->Z) -> (A)->Z? {
    weak var arg = arg
    return { a in
        arg.map(f).map {$0(a)}
    }
}

public func ~><T : AnyObject, A, Z>(arg:T, _ f:@escaping (T)->(A)->Z) -> (A)->Z? {
    return weakapply(arg: arg, to: f)
}

public func weakapply<T : AnyObject, A>(arg:T, to f:@escaping (T, A)->()) -> (A)->() {
    return weakapply(arg: arg, to: curry(f))
}

public func ~><T : AnyObject, A>(arg:T, f:@escaping (T, A)->()) -> (A)->() {
    return weakapply(arg: arg, to: f)
}

public func weakapply<T : AnyObject, A, Z>(arg:T, to f:@escaping (T, A)->Z) -> (A)->Z? {
    return weakapply(arg: arg, to: curry(f))
}

public func ~><T : AnyObject, A, Z>(arg:T, f:@escaping (T, A)->Z) -> (A)->Z? {
    return weakapply(arg: arg, to: f)
}
