//
//  GenreManager.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/20.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

internal final class GenreManager {
    
    /// シングルトンインスタンス
    static let shared = GenreManager()
    
    /** ジャンル一覧情報をRealmに保存
     - parameter genreList: ジャンル一覧情報  **/
    func saveGenreListToRealm(_ genreList: [Genre]) {
        let realm = try! Realm()
        try! realm.write {
            for genre in genreList {
                if let _ = realm.object(ofType: Genre.self, forPrimaryKey: genre.genreId) {
                    realm.add(genre, update: true)
                } else {
                    realm.add(genre, update: true)
                }
            }
        }
    }
    
    /// ジャンル一覧情報をRealmから取得
    func genreListDataFromRealm(predicate: NSPredicate? = nil, realm: Realm = try! Realm()) -> [Genre] {
        let sortParameters = [SortDescriptor(keyPath: "genreId", ascending: true)]
        guard let predicate = predicate else {
            return Array(realm.objects(Genre.self).sorted(by: sortParameters))
        }
        return Array(realm.objects(Genre.self).filter(predicate).sorted(by: sortParameters))
    }
    
    /// ジャンルをRealmから取得
    func genreDataFromRealm(predicate: NSPredicate, realm: Realm = try! Realm()) -> Genre {
        return realm.objects(Genre.self).filter(predicate).first ?? Genre()
    }
    
    /// ジャンルマスタを保存
    func saveDefaultGenreList() {
        let plistPath = Bundle.main.path(forResource: "genre", ofType: "plist")!
        let genreListJson = NSArray(contentsOfFile: plistPath) as! [[String : Any]]
        let genreList: [Genre] = Mapper<Genre>().mapArray(JSONArray: genreListJson)
        saveGenreListToRealm(genreList)
    }
}
