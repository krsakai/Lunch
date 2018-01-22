//
//  TableHeaderView.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/23.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit

internal final class TableHeaderView: UIView {
    @IBOutlet private var titleLabel: UILabel!
    
    static func instantiate(owner: AnyObject, title: String) -> TableHeaderView {
        let view = R.nib.tableHeaderView.firstView(owner: owner)!
        view.titleLabel.text = title
        view.backgroundColor = DeviceModel.themeColor.color
        return view
    }
}
