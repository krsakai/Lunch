//
//  SearchRange.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/21.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import Foundation

internal enum SearchRange: String {
    case tiny   = "1"
    case small  = "2"
    case middle = "3"
    case large  = "4"
    case huge   = "5"
    
    var title: String {
        switch self {
        case .tiny:  return "300m"
        case .small: return  "500m"
        case .middle: return "1km"
        case .large: return "2km"
        case .huge: return "3km"
        }
    }
}
