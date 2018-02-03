//
//  Location.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/02/02.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import Foundation
import ObjectMapper

internal final class Location:  Mappable  {
    private(set) var name = ""
    private(set) var latitude: Double = 0
    private(set) var longitude: Double = 0
    
    convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(name: String, latitude: Double, longitude: Double) {
        self.init()
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
//    override init() {}
//
//    required init?(map: Map) {
//        super.init()
//
//        mapping(map: map)
//    }
    
//    required init(coder aDecoder: NSCoder) {
//        self.latitude = aDecoder.decodeObject(forKey: "latitude") as? Double
//        self.longitude = aDecoder.decodeObject(forKey: "longitude") as? Double
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.latitude, forKey: "latitude")
//        aCoder.encode(self.longitude, forKey: "longitude")
//    }
    
    func mapping(map: Map) {
        name        <- map["formatted_address"]
        latitude    <- map["lat"]
        longitude   <- map["lng"]
    }
}
