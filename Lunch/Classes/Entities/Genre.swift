//
//  Genre.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/20.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

internal final class Genre: Object {
    
    @objc dynamic fileprivate(set) var genreId   = UUID().uuidString.replacingOccurrences(of: "-", with: "")
    @objc dynamic fileprivate(set) var name      = ""       // ジャンル名
    @objc dynamic fileprivate(set) var code      = ""       // ジャンルコード
    @objc dynamic var isActive  = true                      // 有効かどうか
    
    
    // MARK: - Override
    
    override static func primaryKey() -> String? {
        return "genreId"
    }
    
    override static func indexedProperties() -> [String] {
        return ["code"]
    }
}

extension Genre {
    /// イニシャライザ
    convenience init(name: String, code: String) {
        self.init()
        self.name = name
        self.code = code
    }
}

extension Genre {
    
    static func predicate(code: String) -> NSPredicate {
        return NSPredicate(format: "code = %@", code)
    }
    
    static func predicate(name: String) -> NSPredicate {
        return NSPredicate(format: "name = %@", name)
    }
}

extension Genre: Mappable {
    
    convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name    <- map["name"]
        code    <- map["code"]
    }
}
