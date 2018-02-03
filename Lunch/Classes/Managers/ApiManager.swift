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
    
    static let manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 10
        return SessionManager(configuration: configuration)
    }()
    
    let apiInfo: ApiInfo
    var parameters: Parameters
    
    init(apiInfo: ApiInfo, extraParameters: Parameters = [:]) {
        self.apiInfo = apiInfo
        self.parameters = apiInfo.parameters
        self.parameters.merge(extraParameters) { oldValue, newValue in
            return oldValue
        }
    }
    
    func request<T: Mappable>(success: @escaping (_ data: [T]) -> Void, fail: @escaping (_ error: Error?) -> Void) {
        ApiManager.manager.request(apiInfo.url, method: apiInfo.method, parameters: parameters).responseJSON { response in
            guard response.result.isSuccess, let value = response.result.value as? Dictionary<String, Any> else {
                fail(response.result.error)
                return
            }
            let list = self.apiInfo.responseJSON(value: value).flatMap { dictionary in
                Mapper<T>().map(JSONObject: dictionary)
            }
            success(list)
        }
    }
}
