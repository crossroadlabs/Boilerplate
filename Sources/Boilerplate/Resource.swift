//===--- Resource.swift ------------------------------------------------------===//
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

public protocol ResourceProtocol {
    associatedtype Object
    
    func with<R>(_ f:(Object) throws -> R) rethrows -> R
}

open class Resource<T> : ResourceProtocol, Named {
    public typealias Object = T
    
    private let _resource:T
    private let _name:String
    private let _finalize:(Resource) throws ->()
    
    convenience public init(resource:T, name:String? = nil, finalize:@escaping (T) throws ->()) {
        self.init(resource: resource, name: name) { resource in
            try resource.with(finalize)
        }
    }
    
    public init(resource:T, name:String? = nil, finalize:@escaping (Resource) throws ->()) {
        _resource = resource
        _name = name ?? String(describing: T.self)
        _finalize = finalize
    }
    
    convenience init?(resource:T?, name:String? = nil, finalize:@escaping (T) throws ->()) {
        guard let resource = resource else {
            return nil
        }
        self.init(resource: resource, name: name, finalize: finalize)
    }
    
    public var name:String {
        return _name
    }
    
    public func with<R>(_ f:(T) throws -> R) rethrows -> R {
        return try f(_resource)
    }
    
    deinit {
        do {
            try _finalize(self)
        } catch let e {
            print("Resource \(_name) was not finalized properly and following error occured: \(e)")
        }
    }
}

public extension ResourceProtocol {
    public func map<B>(_ f:(Object) throws -> B) rethrows -> Resource<B> {
        let name = (self as? Named)?.name ?? nil
        var this:Self? = self
        return try self.with { resource in
            Resource<B>(resource: try f(resource), name: name) { (_:B) in
                if let _ = this {
                    this = nil
                }
            }
        }
    }
}

public protocol ChainableResourceProtocol : ResourceProtocol {
    func prepend<R : ResourceProtocol>(resource:R) -> Self
}

public extension ResourceProtocol {
    public func flatMap<R : ChainableResourceProtocol>(_ f:(Object) throws -> R) rethrows -> R {
        return try self.with(f).prepend(resource: self)
    }
}

public final class ChainableResource<T> : Resource<T>, ChainableResourceProtocol {
    public func prepend<R : ResourceProtocol>(resource: R) -> ChainableResource {
        var old:R? = resource
        var new:ChainableResource! = self
        let name = self.name
        
        return new.with { resource in
            ChainableResource(resource: resource, name: name) { (_:T) in
                //order is important
                new = nil
                
                //if is used to suppress warning (unused var)
                if let _ = old {
                    old = nil
                }
            }
        }
    }
}
