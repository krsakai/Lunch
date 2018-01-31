//
//  UserDefalutKey.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/30.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import Foundation

protocol KeyNamespaceable {
    func namespaced<T: RawRepresentable>(_ key: T) -> String
}

extension KeyNamespaceable {
    
    func namespaced<T: RawRepresentable>(_ key: T) -> String {
        return "\(Self.self).\(key.rawValue)"
    }
}

protocol StringDefaultSettable : KeyNamespaceable {
    associatedtype StringKey : RawRepresentable
}

extension StringDefaultSettable where StringKey.RawValue == String {
    
    func set(_ value: String, forKey key: StringKey) {
        let key = namespaced(key)
        UserDefaults.standard.set(value, forKey: key)
    }
    
    @discardableResult
    func string(forKey key: StringKey) -> String? {
        let key = namespaced(key)
        return UserDefaults.standard.string(forKey: key)
    }
}

protocol IntDefaultSettable : KeyNamespaceable {
    associatedtype IntKey : RawRepresentable
}

extension IntDefaultSettable where IntKey.RawValue == String {

    func set(_ value: Int, forKey key: IntKey) {
        let key = namespaced(key)
        UserDefaults.standard.set(value, forKey: key)
    }

    @discardableResult
    func string(forKey key: IntKey) -> Int? {
        let key = namespaced(key)
        return UserDefaults.standard.integer(forKey: key)
    }
}

protocol BoolDefaultSettable : KeyNamespaceable {
    associatedtype StringKey : RawRepresentable
}

extension BoolDefaultSettable where StringKey.RawValue == String {
    
    func set(_ value: Bool, forKey key: StringKey) {
        let key = namespaced(key)
        UserDefaults.standard.set(value, forKey: key)
    }
    
    @discardableResult
    func string(forKey key: StringKey) -> Bool? {
        let key = namespaced(key)
        return UserDefaults.standard.bool(forKey: key)
    }
}

protocol DoubleDefaultSettable : KeyNamespaceable {
    associatedtype DoubleKey : RawRepresentable
}

extension DoubleDefaultSettable where DoubleKey.RawValue == String {
    
    func set(_ value: Double, forKey key: DoubleKey) {
        let key = namespaced(key)
        UserDefaults.standard.set(value, forKey: key)
    }
    
    @discardableResult
    func string(forKey key: DoubleKey) -> Double? {
        let key = namespaced(key)
        return UserDefaults.standard.double(forKey: key)
    }
}

