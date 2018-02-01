//
//  History.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/20.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import Foundation
import RealmSwift

internal final class History: Object, ClonableObject {
    
    @objc dynamic fileprivate(set) var storeId      = ""        // 店舗ID
    @objc dynamic fileprivate(set) var date         = ""        // 日付
    @objc dynamic fileprivate(set) var genreCode    = ""        // ジャンルコード
    
    var store: Store? {
        return StoreManager.shared.storeDataFromRealm(predicate: Store.predicate(storeId: storeId))
    }
    
    var genre: Genre {
        return GenreManager.shared.genreDataFromRealm(predicate: Genre.predicate(code: genreCode))
    }
    
    // MARK: - Override
    
    override static func primaryKey() -> String? {
        return "date"
    }
    
    override static func indexedProperties() -> [String] {
        return ["date"]
    }
    
    func updateColumn(reference: History) -> History {
        self.storeId = reference.storeId
        self.date = reference.date
        self.genreCode = reference.genreCode
        return self
    }
}

extension History {
    convenience init(store: Store? = nil, genre: Genre) {
        self.init()
        self.storeId = store?.storeId ?? ""
        self.date = Date().stringFromDate(format: .displayedYearToDay)
        self.genreCode = genre.code
    }
}

extension History {
    
    static func predicate(storeId: String) -> NSPredicate {
        return NSPredicate(format: "storeId = %@", storeId)
    }
    
    static func predicate(dateString: String) -> NSPredicate {
        return NSPredicate(format: "date = %@", dateString)
    }
    
    static var predicateCurrentDate: NSPredicate {
        return NSPredicate(format: "date = %@", Date().stringFromDate(format: .displayedYearToDay))
    }
}
