//
//  Error.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/31.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import Foundation

internal enum LunchError {
    case network
    case location
    
    var title: String {
        switch self {
        case .network:
            return "通信エラー"
        case .location:
            return "位置情報の取得エラー"
        }
    }
    
    var message: String {
        switch self {
        case .network:
            return "ネットワーク環境をご確認のお上、もう一度お試しください"
        case .location:
            return "位置情報の設定をご確認の上、もう一度お試しください"
        }
    }
}
