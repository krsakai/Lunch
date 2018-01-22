//
//  ThemeButton.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/23.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit

internal final class ThemeButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTitleColor(DeviceModel.themeColor.color, for: .normal)
    }
}
