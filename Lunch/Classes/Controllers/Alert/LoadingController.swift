//
//  LoadingController.swift
//  Lunch
//
//  Created by 酒井邦也 on 2017/03/09.
//  Copyright © 2017年 酒井邦也. All rights reserved.


import Foundation
import KRProgressHUD

internal class LoadingController {
    
    typealias LoadingCompletion = (() -> Void)?
    private var loadingCompletion: LoadingCompletion = nil
    
    static let shared = LoadingController()
    
    init() {
        KRProgressHUD.set(style: .white)
        KRProgressHUD.set(maskType: .black)
        KRProgressHUD.set(activityIndicatorViewStyle: .color(DeviceModel.themeColor.color))
    }
    
    func show(title: String = "ロード中") {
        KRProgressHUD.show(withMessage: title)
    }
    
    func hide(completion: (() -> Void)? = nil) {
        KRProgressHUD.dismiss(completion)
    }
}

protocol LoadingDisplayable {
    func showLoading()
    func hideLoading(completion: (() -> Void)?)
}

extension UIViewController: LoadingDisplayable {
    func showLoading() {
        LoadingController.shared.show()
    }
    
    func hideLoading(completion: (() -> Void)? = nil) {
        LoadingController.shared.hide(completion: completion)
    }
}

