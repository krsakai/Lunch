//
//  HeaderView.swift
//  Lunch
//
//  Created by 酒井邦也 on 2017/02/25.
//  Copyright © 2017年 酒井邦也. All rights reserved.
//

import UIKit
import SnapKit

/// ヘッダービュー表示適合用
internal protocol HeaderViewDisplayable: AnyObject {
    
    /// ヘッダー
    var headerView: HeaderView! { get }
    
    /// ヘッダーの初期化処理
    func setupHeaderView(_ title: String, headerItems: HeaderItems?)
    
    /// ヘッダーの更新処理 (指定したヘッダーアイテムのボタンの活性化状態を変更する)
    func refreshHeaderView(enabled: Bool, headerItems: HeaderItems?)
    
    /// ヘッダーボタン押下時
    func didTapHeaderButton(buttonType: HeaderButtonType)
}

extension HeaderViewDisplayable {
    
    func setupHeaderView(_ title: String, headerItems: HeaderItems? = nil) {
        
        headerView.title.text = title
        headerView.headerItems = headerItems
        
        guard let headerItems = headerItems else {
            return
        }
        
        if let leftButtonItems = headerItems.leftItems {
            setupHeaderButton(stackView: headerView.leftStackView, headerItems: leftButtonItems)
        }
        
        if let rightButtonItems = headerItems.rightItems {
            setupHeaderButton(stackView: headerView.rightStackView, headerItems: rightButtonItems)
        }
    }
    
    func refreshHeaderView(enabled: Bool, headerItems: HeaderItems? = nil) {
        
        guard let headerItems = headerItems else {
            return
        }
        
        if let leftButtonItems = headerItems.leftItems {
            refreshHeaderButton(enabled: enabled, headerItems: leftButtonItems)
        }
        
        if let rightButtonItems = headerItems.rightItems {
            refreshHeaderButton(enabled: enabled, headerItems: rightButtonItems)
        }
    }
    
    func didTapHeaderButton(buttonType: HeaderButtonType) {
        switch buttonType {
        default:
            AppDelegate.sideMenu?.evo_drawerController?.toggleLeftDrawerSide(animated: true, completion: nil)
        }
    }
    
    // MARK: - Private Function
    
    private func setupHeaderButton(stackView: UIStackView, headerItems: [HeaderButtonType]) {
        headerItems.forEach { buttonType in
            let buttonView = HeaderButtonView.instantiate(owner: self, buttonType: buttonType)
            stackView.addArrangedSubview(buttonView)
            buttonView.snp.makeConstraints { make in
                make.width.equalTo(40)
            }
            headerView.buttons.append(buttonView)
        }
    }
    
    private func refreshHeaderButton(enabled: Bool, headerItems: [HeaderButtonType]) {
        headerItems.forEach { buttonType in
            self.headerView.buttons.forEach { headerView in
                if headerView.buttonType == buttonType  {
                    headerView.headerButton.isEnabled = enabled
                }
            }
        }
    }
}

/// ヘッダービュー
internal final class HeaderView: UIView {
    
    fileprivate var headerItems: HeaderItems?
    fileprivate var buttons: [HeaderButtonView] = []
    
    // MARK: IBOutlet

    @IBOutlet fileprivate weak var leftStackView: UIStackView!
    @IBOutlet fileprivate weak var rightStackView: UIStackView!
    @IBOutlet fileprivate weak var title: UILabel!
    
    fileprivate var contentView: UIView!
    
    // MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = R.nib.headerView.firstView(owner: self, options: nil)!
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.right.left.bottom.top.equalTo(0)
        }
        contentView.backgroundColor = DeviceModel.themeColor.color
    }
}

extension HeaderView: LayoutUpdable {
    func refreshLayout() {
        contentView.backgroundColor = DeviceModel.themeColor.color
    }
}
