//
//  AlertController.swift
//  Lunch
//
//  Created by 酒井邦也 on 2017/03/07.
//  Copyright © 2017年 酒井邦也. All rights reserved.
//

import UIKit
import SCLAlertView
import SnapKit

typealias AlertButton = (label: String, action: () -> Swift.Void)

typealias AlertMessage = (title: String?, message: String?)
internal enum AlertType {
    case info(message: AlertMessage)
    case edit(message: AlertMessage)
    case regist(message: AlertMessage)
    case loading(message: AlertMessage)
    case error(message: AlertMessage)
    
    func showAlert(alertView: SCLAlertView?) {
        switch self {
        case .info(let message):
            let title = message.title ?? ""
            let subtitle = message.message ?? ""
            alertView?.showInfo(title, subTitle: subtitle, colorStyle: UInt(DeviceModel.themeColor.hexValue))
        case .edit(let message):
            let title = message.title ?? ""
            let subtitle = message.message ?? ""
            alertView?.showEdit(title, subTitle: subtitle, colorStyle: UInt(DeviceModel.themeColor.hexValue))
        case .regist(let message):
            let title = message.title ?? ""
            let subtitle = message.message ?? ""
            alertView?.showSuccess(title, subTitle: subtitle)
        case .loading(let message):
            let title = message.title ?? ""
            let subtitle = message.message ?? ""
            alertView?.showWait(title, subTitle: subtitle)
        case .error(let message):
            let title = message.title ?? ""
            let subtitle = message.message ?? ""
            alertView?.showError(title, subTitle: subtitle, closeButtonTitle: nil)
        }
    }
}

internal class AlertController {
    
    static let shared = AlertController()
    
    var alertView: SCLAlertView?
    
    func show(alertType: AlertType, buttonList: [AlertButton]?, textFiled: UITextField? = nil) {
        alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance.init(showCloseButton: false))
        if let buttonList = buttonList {
            buttonList.forEach { button in
                alertView?.addButton(button.label, action: button.action)
            }
        }
        if let textFiled = textFiled {
            let subview = UIView(frame: CGRect(x: 0, y: 0, width: textFiled.frame.width, height: textFiled.frame.height))
            textFiled.layer.borderColor = DeviceModel.themeColor.color.cgColor
            textFiled.layer.borderWidth = 1
            textFiled.layer.cornerRadius = 5
            textFiled.textAlignment = .natural
            subview.addSubview(textFiled)
            alertView?.customSubview = subview
        }
        alertType.showAlert(alertView: alertView)
    }
    
    func hide() {
        alertView?.hideView()
    }
    
    static func showAlert(title: String? = "", message: String = "", enableCancel: Bool = true, positiveLabel: String = R.string.localizable.commonLabelOK(), negativeLabel: String = R.string.localizable.commonLabelCancel(), positiveAction: (() -> Void)? = nil, negativeAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: positiveLabel, style: .default) { _ in positiveAction?() })
        if enableCancel { alert.addAction(UIAlertAction(title: negativeLabel, style: .default) { _ in negativeAction?() }) }
        UIApplication.topViewController()?.present(alert, animated: true)
    }
}

protocol AlertDisplayable {
    func showAlert(alertType: AlertType, buttonList: [AlertButton]?)
    func showAlert(alertType: AlertType, buttonList: [AlertButton]?, textFiled: UITextField?)
}

extension UIViewController: AlertDisplayable {
    
    func showAlert(alertType: AlertType, buttonList: [AlertButton]?) {
        self.showAlert(alertType: alertType, buttonList: buttonList, textFiled: nil)
    }
    
    func showAlert(alertType: AlertType, buttonList: [AlertButton]?, textFiled: UITextField? = nil) {
        return AlertController.shared.show(alertType: alertType, buttonList: buttonList, textFiled: textFiled)
    }
}
