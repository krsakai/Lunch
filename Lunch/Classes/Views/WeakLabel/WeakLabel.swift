//
//  WeakLabel.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/22.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit

@IBDesignable
internal final class WeakLabel: UILabel {
    @IBInspectable var textColors: UIColor! {
        didSet {
            self.textColor = LunchColor.Label.weak
        }
    }
}
