//
//  ApiManager.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/20.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

// API実行管理オブジェクト
internal struct ApiManager {
    
    let apiInfo: ApiInfo
    var parameters: Parameters
    
    init(apiInfo: ApiInfo, extraParameters: Parameters = [:]) {
        self.apiInfo = apiInfo
        self.parameters = apiInfo.parameters
        self.parameters.merge(extraParameters) { oldValue, newValue in
            return oldValue
        }
        self.parameters.merge(["count": "100"]) { oldValue, newValue in
            return oldValue
        }
        self.parameters.merge(["key": apiInfo.apiKey]) { oldValue, newValue in
            return oldValue
        }
        self.parameters.merge(["format": "json"]) { oldValue, newValue in
            return oldValue
        }
    }
    
    func request<T: Mappable>(success: @escaping (_ data: [T]) -> Void, fail: @escaping (_ error: Error?) -> Void) {
        Alamofire.request(apiInfo.url, method: apiInfo.method, parameters: parameters).responseJSON { response in
            print(response.request?.url?.absoluteString)
            guard response.result.isSuccess, let value = response.result.value as? Dictionary<String, Any> else {
                fail(response.result.error)
                return
            }
            let list = self.apiInfo.responseJSON(value: value).flatMap { (param, json) in
                Mapper<T>().map(JSONObject: json.dictionaryObject)
            }
            success(list)
        }
    }
}
