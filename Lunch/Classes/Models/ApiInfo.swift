//
//  ApiInfo.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/20.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper
import CoreLocation

internal enum StoreSearchCondition {
    case locationOnly         // 現在地のみ
    case keyword(String)      // キーワード
    case genre(Genre)         // ジャンル
    
    func apiInfo(location: CLLocation) -> ApiInfo {
        switch self {
        case .locationOnly:
            return ApiInfo.searchStore(location: location)
        case .keyword(let keyword):
            return ApiInfo.searchStoreFromKeyword(location: location, keyword: keyword)
        case .genre(let genre):
            return ApiInfo.searchStoreFromGenre(location: location, genre: genre)
        }
    }
}

internal enum ApiInfo {
    
    case searchStore(location: CLLocation)
    case searchStoreFromGenre(location: CLLocation, genre: Genre)
    case searchStoreFromKeyword(location: CLLocation, keyword: String)
    case geocoding(keyword: String)
    
    var apiKey: String {
        switch self {
        case .geocoding:
            return "AIzaSyA0osDFGKTiWr18gZB6KowRHI5JH_SveVU"
        default:
            return "12687151f2b51658" // ホットペッパーAPIKey
        }
        
    }
    
    var host: String {
        switch self {
        case .searchStore, .searchStoreFromGenre, .searchStoreFromKeyword:
            return "https://webservice.recruit.co.jp/" // ホットペッパーAPIプロトコル + ドメイン
        case .geocoding:
            return "https://maps.googleapis.com/"
        }
    }
    
    var path: String {
        switch self {
        case .searchStore, .searchStoreFromKeyword, .searchStoreFromGenre:
            return "hotpepper/gourmet/v1/" // グルメサーチAPI
        case .geocoding:
            return "maps/api/geocode/json"
        }
    }
    
    var url: String {
        return self.host + self.path
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any] {
        switch self {
        case .searchStore(let location):
            return
                    [
                        "lat": String(location.coordinate.latitude),
                        "lng": String(location.coordinate.longitude),
                        "range": DeviceModel.searchRange.rawValue,
                        "count": "100",
                        "key": apiKey,
                        "format": "json"
                        
                    ]
        case .searchStoreFromKeyword(let location, let keyword):
            return
                    [
                        "keyword": keyword,
                        "lat": String(location.coordinate.latitude),
                        "lng": String(location.coordinate.longitude),
                        "range": SearchRange.huge.rawValue,
                        "count": "100",
                        "key": apiKey,
                        "format": "json"
                    ]
        case .searchStoreFromGenre(let location, let genre):
            return
                    [
                        "food": genre.code,
                        "lat": String(location.coordinate.latitude),
                        "lng": String(location.coordinate.longitude),
                        "range": DeviceModel.searchRange.rawValue,
                        "count": "100",
                        "key": apiKey,
                        "format": "json"
                    ]
        case .geocoding(let keyword):
            return
                    [
                        "address": keyword,
                        "key": apiKey,
                    ]
        }
    }
    
    // FIXME: 変換エラーを考慮する
    func responseJSON(value: Dictionary<String, Any>) -> JSON {
        switch self {
        case .geocoding:
            return JSON(value)["results"][0]["geometry"]["location"]
        default:
            return JSON(value)["results"]["shop"]
        }
    }
}
