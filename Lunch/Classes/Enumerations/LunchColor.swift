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
        static let green   = UIColor(hex6: 0x93C154)
        
        static let red     = UIColor(hex6: 0xc70067)
        
        static let blue    = UIColor(hex6: 0x043c78)
        
        static let water   = UIColor(hex6: 0x0068B7)
    }
    
    struct Line {
        static let separator = UIColor(hex6: 0x9A9A9A)
    }
    
    struct Label {
        static let weak = UIColor(hex6: 0x969696)
    }
}
