//
//  TableHeaderView.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/23.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit

typealias TableHeaderAction = (label: String, action: (() -> Swift.Void)?)

internal final class TableHeaderView: ThemeColorView {
    
    // MARK: - IBOutlet
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private weak var tableHeaderButton: UIButton!
    
    // MARK: - Property
    
    private var action: TableHeaderAction?
    
    // MARK: - Initialzer
    
    static func instantiate(owner: AnyObject, title: String, action: TableHeaderAction? = nil) -> TableHeaderView {
        let view = R.nib.tableHeaderView.firstView(owner: owner)!
        if let action = action {
            view.action = action
            view.tableHeaderButton.setTitle(action.label, for: .normal)
            view.tableHeaderButton.setTitle(action.label, for: .highlighted)
            view.tableHeaderButton.isHidden = false
        }
        view.titleLabel.text = title
        view.backgroundColor = DeviceModel.themeColor.color
        return view
    }
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableHeaderButton.layer.borderWidth = 1.0
        tableHeaderButton.layer.borderColor = UIColor.white.cgColor
        tableHeaderButton.layer.cornerRadius = 8.0
    }
    
    // MARK: - IBAction
    @IBAction func tableHeaderButtonTapped(_ sender: Any) {
        action?.action?()
    }
}

internal final class TableHeaderButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 8.0
    }
}
