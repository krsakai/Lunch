//
//  LunchHistoryViewController.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/21.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit

internal final class LunchHistoryViewController: UIViewController, HeaderViewDisplayable {
    
    // MARK: - IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    
    // MARK: - Property
    
    // MARK: - Initializer
    
    static func instantiate() -> LunchHistoryViewController {
        return R.storyboard.lunchHistoryViewController.lunchHistoryViewController()!
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let headerItems = HeaderItems(leftItems: [.sideMenu], rightItems: nil)
        setupHeaderView("", headerItems: headerItems)
    }
    
    // MARK: - IBAction
    
}
