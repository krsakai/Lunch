//
//  LunchColor.swift
//  Lunch
//
//  Created by 酒井邦也 on 2017/02/25.
//  Copyright © 2017年 酒井邦也. All rights reserved.
//

import UIKit
import HEXColor

internal struct LunchColor {
    
    struct HeaderButton {
        static let add = UIColor.white
    }
    
    struct Cell {
        static let red = UIColor(hex6: 0xff2828)
    }
    
    struct Common {
        static let greenRawValue    = "93C154"
        static let green            = "93C154".color
        
        static let redRawValue      = "c70067"
        static let red              = "c70067".color
        
        static let blueRawValue     = "043c78"
        static let blue             = "043c78".color
        
        static let waterRawValue    = "0068B7"
        static let water            = "0068B7".color
    }
    
    struct Line {
        static let separator = UIColor(hex6: 0x9A9A9A)
    }
    
    struct Label {
        static let weak = UIColor(hex6: 0x969696)
    }
}
