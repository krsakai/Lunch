//
//  Location.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/02/02.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import Foundation
import ObjectMapper

internal final class Location: Mappable {
    private(set) var latitude: String = ""
    private(set) var longitude: String = ""
    
    convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        latitude    <- map["lat"]
        longitude   <- map["lng"]
    }
}
