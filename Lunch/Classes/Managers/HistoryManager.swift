//
//  HistoryManager.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/20.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

internal final class HistoryManager {
    
    /// シングルトンインスタンス
    static let shared = HistoryManager()
    
    /** 履歴一覧情報をRealmに保存
     - parameter historyList: 履歴一覧情報  **/
    func saveHistoryListToRealm(_ historyList: [History]) {
        let realm = try! Realm()
        try! realm.write {
            for history in historyList {
                if let _ = realm.object(ofType: History.self, forPrimaryKey: history.id) {
                    realm.add(history, update: true)
                } else {
                    realm.add(history, update: true)
                }
            }
        }
    }
    
    /// 履歴一覧情報をRealmから取得
    func historyListDataFromRealm(predicate: NSPredicate? = nil, realm: Realm = try! Realm()) -> [History] {
        let sortParameters = [SortDescriptor(keyPath: "date", ascending: false)]
        guard let predicate = predicate else {
            return Array(realm.objects(History.self).sorted(by: sortParameters))
        }
        return Array(realm.objects(History.self).filter(predicate).sorted(by: sortParameters))
    }
    
    /// 履歴をRealmから取得
    func historyDataFromRealm(predicate: NSPredicate, realm: Realm = try! Realm()) -> History {
        return realm.objects(History.self).filter(predicate).first ?? History()
    }
}

