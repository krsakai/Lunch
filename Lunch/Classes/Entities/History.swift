//
//  History.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/20.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import Foundation
import RealmSwift

internal final class History: Object {
    
    @objc dynamic fileprivate(set) var id           = UUID().uuidString.replacingOccurrences(of: "-", with: "")
    @objc dynamic fileprivate(set) var storeId      = ""        // 店舗ID
    @objc dynamic fileprivate(set) var date         = Date()    // 日付
    @objc dynamic fileprivate(set) var genreCode    = ""        // ジャンルコード
    
    // MARK: - Override
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["date"]
    }
}

extension History {
    
    static func predicate(storeId: String) -> NSPredicate {
        return NSPredicate(format: "storeId = %@", storeId)
    }
    
    static func predicate(name: String) -> NSPredicate {
        return NSPredicate(format: "name = %@", name)
    }
}
