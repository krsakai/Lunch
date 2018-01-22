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

internal enum ApiInfo {
    
    case searchStoreFromLocation(location: CLLocation)
    case searchStoreFromKeyword(keyword: String)
    
    var apiKey: String {
        return  "12687151f2b51658" // ホットペッパーAPIKey
    }
    
    var host: String {
        return "https://webservice.recruit.co.jp/" // ホットペッパーAPIプロトコル + ドメイン
    }
    
    var path: String {
        switch self {
        case .searchStoreFromLocation, .searchStoreFromKeyword:
            return "hotpepper/gourmet/v1/" // グルメサーチAPI
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
        case .searchStoreFromLocation(let location):
            return
                    [
                        "lat": String(location.coordinate.latitude),
                        "lng": String(location.coordinate.longitude),
                        "range": DeviceModel.searchRange.rawValue
                    ]
        case .searchStoreFromKeyword(let keyword):
            return
                    [
                        "keyword": keyword
                    ]
        }
    }
    
    // FIXME: 変換エラーを考慮する
    func responseJSON(value: Dictionary<String, Any>) -> JSON {
        switch self {
        case .searchStoreFromLocation, .searchStoreFromKeyword:
            return JSON(value)["results"]["shop"]
        }
    }
}
