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
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var tableView: IgnoreTouchTableView!
    
    // MARK: - Property
    fileprivate var historyList: [History] = []
    
    // MARK: - Initializer
    
    static func instantiate() -> LunchHistoryViewController {
        return R.storyboard.lunchHistoryViewController.lunchHistoryViewController()!
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let headerItems = HeaderItems(leftItems: [.sideMenu], rightItems: nil)
        setupHeaderView("履歴", headerItems: headerItems)
        tableView.register(StoreInfoTableCell.self)
        historyList = HistoryManager.shared.historyListDataFromRealm()
    }
    
    // MARK: - IBAction
    
}

// MARK: - UITableViewDataSource

extension LunchHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as StoreInfoTableCell
        cell.setup(store: historyList[indexPath.section].store)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension LunchHistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableHeaderView.instantiate(owner: self, title: historyList[section].date)
    }
}

// MARK: - ScreenReloadable

extension LunchHistoryViewController: ScreenReloadable {
    func reloadScreen() {
        view.layoutUpdableViews.forEach { $0.refreshLayout() }
        tableView.reloadData()
    }
}
