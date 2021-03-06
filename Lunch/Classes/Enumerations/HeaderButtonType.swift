//
//  HeaderButtonType.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/21.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit

typealias HeaderItems = (leftItems: [HeaderButtonType]?, rightItems: [HeaderButtonType]?)
internal enum HeaderButtonType {
    case sideMenu   // サイドメニュー
    case close      // 閉じる
    case back       // 戻る
    case add        // 追加
    case bulk       // 一括
    
    var image: UIImage? {
        switch self {
        case .sideMenu: return R.image.universalGeneralSideMenuBarButton()
        case .close: return R.image.universalGeneralCloseButton()
        case .back: return R.image.universalGeneralLeftArrowWhite()
        default: return nil
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .sideMenu: return R.image.universalGeneralSideMenuBarButton_Selected()
        case .close: return R.image.universalGeneralCloseButton_Selected()
        case .back: return R.image.universalGeneralLeftArrowWhite_Selected()
        default:  return nil
        }
    }
    
    var title: String? {
        switch self {
        case .add   : return R.string.localizable.commonLabelPlus()
        case .bulk  : return "一括"
        default: return nil
        }
    }
    
    var titleFont: UIFont {
        return LunchFont.HeaderButton.regist
    }
    
    var tintColor: UIColor {
        return LunchColor.HeaderButton.add
    }
}
