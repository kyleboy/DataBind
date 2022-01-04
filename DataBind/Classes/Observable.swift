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
    public private(set) var flag: String
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
    
    public init(owner o: AnyObject?, flag f: String = "default", handler h: @escaping HandlerType) {
        if o == nil {
            _value = { false }
        } else {
            _value = { [weak o] in o != nil }
        }
        owner = { [weak o] in o }
        handler = h
        flag = f
    }
    
    deinit {
        log("\(#function) \(type(of: self))")
    }
    
}

public class Event<T> {
    public typealias HandlerType = (T) -> ()
    
    var subscriptions: [Subscription<T>] = []
    
    @discardableResult
    public func add(owner: AnyObject?, flag: String, handler: @escaping HandlerType) -> Subscription<T> {
        let subscriber = Subscription(owner: owner, flag: flag, handler: handler);
        add(subscription: subscriber)
        return subscriber
    }
    
    public func add(subscription: Subscription<T>) {
        subscriptions.append(subscription)
    }
        
    public func remove(subscription: Subscription<T>) {
        subscriptions.removeAll { $0 === subscription }
    }
    
    func notify(_ value: T) {
        subscriptions.removeAll { !$0.value() }
        subscriptions.forEach { subscriber in
            subscriber.handler(value)
        }
    }
}

extension Event {
    public func remove(flag: String) {
        subscriptions.removeAll { $0.flag == flag }
    }
    
    public func remove(onwer: AnyObject) {
        subscriptions.removeAll { $0.owner() === onwer }
    }
}


// MARK: - Publisher
public protocol Publisher {
    associatedtype ValueType
    typealias ValueChangeType = ValueChange<ValueType>
    
    var event: Event<ValueChangeType> { get }
    var value: ValueType { get set }
    
    init(_ v: ValueType)
    
    /// 添加一个监听
    /// - Parameters:
    ///   - owner: 监听者
    ///   - handler: 数据变化回调
    @discardableResult
    func change(owner: AnyObject?, flag: String, handler: @escaping (ValueChangeType) -> ()) -> Subscription<ValueChangeType>
    
    func remove(subscription: Subscription<ValueChangeType>) -> Self
}

extension Publisher {
    @discardableResult
    public func change(owner: AnyObject?, flag: String = "default", handler: @escaping (ValueChangeType) -> ()) -> Subscription<ValueChangeType> {
        if owner != nil {
            handler(ValueChangeType(value, value))
        }
        return event.add(owner: owner, flag: flag, handler: handler)
    }
    
    @discardableResult
    public func bind<T: AnyObject>(owner: T, flag: String = "default", keyPath: WritableKeyPath<T, ValueType>) -> Subscription<ValueChangeType> {
        return change(owner: owner, flag: flag) { [weak owner] value in
            owner?[keyPath: keyPath] = value.newValue
        }
    }
    
    @discardableResult
    public func remove(subscription: Subscription<ValueChangeType>) -> Self {
        event.remove(subscription: subscription)
        return self
    }
    
    @discardableResult
    public func remove(flag: String) -> Self {
        event.remove(flag: flag)
        return self
    }
    
    @discardableResult
    public func remove(onwer: AnyObject) -> Self {
        event.remove(onwer: onwer)
        return self
    }
}

public struct Subject<T>: Publisher {
    public typealias ValueType = T
    public typealias ValueChangeType = ValueChange<T>
    
    public var event = Event<ValueChangeType>()
    
    public var value: ValueType {
        didSet { event.notify(ValueChange(oldValue, value))}
    }

    public init(_ v: T) {
        value = v
    }
}

@propertyWrapper public struct Observable<T>: Publisher {
    
    public typealias ValueType = T
    public typealias ValueChangeType = ValueChange<T>
    
    public var event = Event<ValueChangeType>()
    public var value: ValueType {
        get { wrappedValue }
        set { wrappedValue = newValue }
    }
    
    public var wrappedValue: ValueType {
        didSet { event.notify(ValueChange(oldValue, wrappedValue))}
    }
    
    public var projectedValue: Self {
        return self
    }
    
    public init(_ v: T) {
        wrappedValue = v
    }
    
    public init(wrappedValue v: ValueType) {
        wrappedValue = v
    }
}


func log(_ msg: String) {
    debugPrint("Observable \(msg)")
}
