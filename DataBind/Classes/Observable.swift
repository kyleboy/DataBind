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

public class Subscription<T> {
    public typealias HandlerType = (T) -> ()
    
    private var _value: () -> Bool
    public private(set) var handler: HandlerType
    public private(set) var owner: () -> AnyObject?
    
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
        owner = { [weak o] in o }
        handler = h
    }
    
    deinit {
        log("\(#function) \(type(of: self))")
    }
    
}

public class Event<T> {
    public typealias HandlerType = (T) -> ()
    
    private var subscriptions: [Subscription<T>] = []
    
    @discardableResult
    public func add(owner o: AnyObject?, handler h: @escaping HandlerType) -> Subscription<T> {
        let subscriber = Subscription(owner: o, handler: h);
        add(subscription: subscriber)
        return subscriber
    }
    
    public func add(subscription: Subscription<T>) {
        subscriptions.append(subscription)
    }
    
    
    /// 保证此owner只有一个订阅
    /// - Parameters:
    ///   - o: 监听者的对象
    ///   - h: 数据改变回调
    /// - Returns: 订阅
    @discardableResult
    public func one(owner o: AnyObject?, handler h: @escaping HandlerType) -> Subscription<T> {
        subscriptions.removeAll { $0.owner() === o }
        
        let subscriber = Subscription(owner: o, handler: h);
        add(subscription: subscriber)
        return subscriber
    }
    
    public func remove(subscriber: Subscription<T>) {
        subscriptions.removeAll { $0 === subscriber }
    }
    
    func notify(_ value: T) {
        subscriptions.removeAll { !$0.value() }
        subscriptions.forEach { subscriber in
            subscriber.handler(value)
        }
    }
}

@propertyWrapper public struct Observable<T> {
    
    public typealias ValueType = T
    
    public var change = Event<ValueChange<T>>()
    
    public var wrappedValue: ValueType {
        didSet { change.notify(ValueChange(oldValue, wrappedValue))}
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
