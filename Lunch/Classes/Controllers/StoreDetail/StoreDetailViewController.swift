//
//  StoreDetailViewController.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/26.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

internal final class StoreDetailViewController: UIViewController, HeaderViewDisplayable {
    
    // MARK: - IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Property
    fileprivate var webView: WKWebView!
    fileprivate var store: Store?
    
    // MARK: - Initializer
    
    static func instantiate(store: Store?) -> StoreDetailViewController {
        let viewController = R.storyboard.storeDetailViewController.storeDetailViewController()!
        viewController.store = store
        return viewController
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView(store?.name ?? "", headerItems: HeaderItems([.back], nil))
        setupWebView()
        if let store = store, !store.url.isEmpty {
            showLoading()
            webView.load(URLRequest(url: URL(string: store.url)!))
        }
        
    }
    
    // MARK: - IBAction
    
    
    // MARK: - Private Func
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView (frame: CGRect(x: 0, y: 0, width: 0, height: 0) , configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.right.bottom.left.equalTo(0)
        }
        webView.navigationDelegate = self
    }
}

extension StoreDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoading()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hideLoading() {
            let alertMessage = AlertMessage(title: "タイトル", message: "このジャンルでよろしいですか？")
            let alertType = AlertType.error(message: alertMessage)
            var buttonList = [AlertButton(label: "このジャンルでお店を検索する") {
                
                }]
            if !DeviceModel.isOverLunch {
                buttonList.append(AlertButton(label: "お店は歩いて探す") {
                    
                })
            }
            buttonList.append(AlertButton(label: "選び直す"){})
            self.showAlert(alertType: alertType, buttonList: buttonList)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoading() {
            let alertMessage = AlertMessage(title: "タイトル", message: "このジャンルでよろしいですか？")
            let alertType = AlertType.error(message: alertMessage)
            var buttonList = [AlertButton(label: "このジャンルでお店を検索する") {
                
                }]
            if !DeviceModel.isOverLunch {
                buttonList.append(AlertButton(label: "お店は歩いて探す") {
                    
                })
            }
            buttonList.append(AlertButton(label: "選び直す") {
                
            })
            self.showAlert(alertType: alertType, buttonList: buttonList)
        }
    }
}
