//
//  Store.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/20.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

internal final class Store: Object {
    
    @objc dynamic fileprivate(set) var id           = UUID().uuidString.replacingOccurrences(of: "-", with: "")
    @objc dynamic fileprivate(set) var storeId      = ""    // 店舗ID
    @objc dynamic fileprivate(set) var name         = ""    // 店舗名
    @objc dynamic fileprivate(set) var address      = ""    // 住所
    @objc dynamic fileprivate(set) var open         = ""    // 営業日
    @objc dynamic fileprivate(set) var close        = ""    // 定休日
    @objc dynamic fileprivate(set) var latitude     = ""    // 緯度
    @objc dynamic fileprivate(set) var longitude    = ""    // 軽度
    @objc dynamic fileprivate(set) var genreCode    = ""    // ジャンルコード (food.code)
    @objc dynamic fileprivate(set) var url          = ""    // 店舗詳細URL
    @objc dynamic fileprivate(set) var imageUrl     = ""    // 店舗画像URL
    
    // MARK: - Override
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["storeId"]
    }
}

extension Store {
    
    static func predicate(storeId: String) -> NSPredicate {
        return NSPredicate(format: "storeId = %@", storeId)
    }
    
    static func predicate(name: String) -> NSPredicate {
        return NSPredicate(format: "name = %@", name)
    }
}

extension Store: Mappable {
    
    convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        storeId     <- map["id"]
        name        <- map["name"]
        address     <- map["address"]
        open        <- map["open"]
        close       <- map["close"]
        latitude    <- map["lat"]
        longitude   <- map["lng"]
        genreCode   <- map["food.code"]
        url         <- map["urls.pc"]
        imageUrl    <- map["photo.pc.m"]
    }
}
