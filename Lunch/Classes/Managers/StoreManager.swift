//
//  StoreManager.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/20.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import SwiftTask
import CoreLocation

internal final class StoreManager {
    
    /// シングルトンインスタンス
    static let shared = StoreManager()
    
    typealias StoreListDataTask = Task<Void, [Store], LunchError>
    /// 検索店舗一覧を保存・取得する
    private func searchStoreListData(apiInfo: ApiInfo) -> StoreListDataTask {
        return StoreListDataTask { _, fulfill, reject, _ in
            ApiManager(apiInfo: apiInfo).request(success: { [weak self] (storeList: [Store])  in
                guard let weakSelf = self else {
                    return reject(LunchError.network)
                }
                weakSelf.saveStoreListToRealm(storeList)
                fulfill(storeList)
            }, fail: { error in
                reject(LunchError.network)
            })
        }
    }
    
    /// 現在地から検索した店舗一覧を取得する
    func searchStoreListDataFromLocation(condition: StoreSearchCondition = .locationOnly) -> StoreListDataTask {
        return StoreListDataTask { _, fulfill, reject, _ in
            LocationManager.shared.currentLocationTask().success { location in
                self.searchStoreListData(apiInfo: condition.apiInfo(location: location)).success { storeList in
                    fulfill(storeList)
                }.failure { _ in
                    reject(LunchError.network)
                }
            }
        }
    }
    
    /// 店舗一覧情報をRealmに保存
    private func saveStoreListToRealm(_ storeList: [Store]) {
        let realm = try! Realm()
        try! realm.write {
            for store in storeList {
                if let _ = realm.object(ofType: Store.self, forPrimaryKey: store.storeId) {
                    realm.add(store, update: true)
                } else {
                    realm.add(store, update: true)
                }
            }
        }
    }
    
    /// 店舗一覧情報をRealmから取得
    func storeListDataFromRealm(predicate: NSPredicate? = nil, realm: Realm = try! Realm()) -> [Store] {
        let sortParameters = [SortDescriptor(keyPath: "code", ascending: true)]
        guard let predicate = predicate else {
            return Array(realm.objects(Store.self).sorted(by: sortParameters))
        }
        return Array(realm.objects(Store.self).filter(predicate).sorted(by: sortParameters))
    }
    
    /// 店舗をRealmから取得
    func storeDataFromRealm(predicate: NSPredicate, realm: Realm = try! Realm()) -> Store? {
        return realm.objects(Store.self).filter(predicate).first
    }
    
    /// 店舗マスタを保存
    func saveDefaultStoreList() {
        let plistPath = Bundle.main.path(forResource: "store", ofType: "plist")!
        let storeListJson = NSArray(contentsOfFile: plistPath) as! [[String : Any]]
        let storeList: [Store] = Mapper<Store>().mapArray(JSONArray: storeListJson)
        saveStoreListToRealm(storeList)
    }
}

