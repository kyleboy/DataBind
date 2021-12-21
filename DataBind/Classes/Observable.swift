//
//  Observable.swift
//  DataBind
//
//  Created by 王英辉 on 2021/12/12.
//

import Foundation

public struct ValueChange<T> {
    public let oldValue: T
    public let newValue: T
    public init(_ o: T, _ n: T) {
        oldValue = o
        newValue = n
    }
}

extension ValueChange {
    public func transform<U>(_ handler: (ValueChange<T>) -> U) -> U {
        return handler(self)
    }
}

public class Subscriber<T> {
    public typealias HandlerType = (T) -> ()
    
    private var _value: () -> Bool
    public private(set) var handler: HandlerType
    
    public func value() -> Bool {
        if !_value() {
            invalidate()
            return false
        } else {
            return true
        }
    }
    
    public func invalidate() {
        _value = { false }
        handler = { _ in () }
    }
    
    public init(owner o: AnyObject?, handler h: @escaping HandlerType) {
        if o == nil {
            _value = { false }
        } else {
            _value = { [weak o] in o != nil }
        }
        handler = h
    }
    
    deinit {
        log("\(#function) \(type(of: self))")
    }
    
}

public class Event<T> {
    public typealias HandlerType = (T) -> ()
    
    private var subscription: [Subscriber<T>] = []
    
    @discardableResult
    public func add(owner o: AnyObject?, handler h: @escaping HandlerType) -> Subscriber<T> {
        let subscriber = Subscriber(owner: o, handler: h);
        add(subscriber: subscriber)
        return subscriber
    }
    
    public func add(subscriber: Subscriber<T>) {
        subscription.append(subscriber)
    }
    
    public func remove(subscriber: Subscriber<T>) {
        subscription.removeAll { $0 === subscriber }
    }
    
    func notify(_ value: T) {
        subscription.removeAll { !$0.value() }
        subscription.forEach { subscriber in
            subscriber.handler(value)
        }
    }
}

@propertyWrapper public struct Observable<T> {
    
    public typealias ValueType = T
    
    public var beforeChange = Event<ValueChange<T>>()
    public var afterChange = Event<ValueChange<T>>()
    
    
    public var wrappedValue: ValueType {
        willSet { beforeChange.notify(ValueChange(wrappedValue, newValue))}
        didSet { afterChange.notify(ValueChange(oldValue, wrappedValue))}
    }
    
    public var projectedValue: Self {
        return self
    }
    
    public init(wrappedValue v: T) {
        wrappedValue = v
    }
}

func log(_ msg: String) {
    debugPrint("Observable \(msg)")
}
