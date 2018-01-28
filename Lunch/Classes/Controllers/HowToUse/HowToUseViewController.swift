//
//  HowToUseViewController.swift
//  Lunch
//
//  Created by 酒井邦也 on 2017/04/09.
//  Copyright © 2017年 酒井邦也. All rights reserved.
//

import UIKit

internal final class HowToUseViewController: UIViewController, HeaderViewDisplayable {

    @IBOutlet var headerView: HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView("使い方", headerItems: HeaderItems(leftItems: [.close], rightItems: nil))
    }
}

