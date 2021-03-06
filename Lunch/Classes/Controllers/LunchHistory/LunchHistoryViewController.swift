//
//  LunchHistoryViewController.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/21.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit
import SWTableViewCell
import DZNEmptyDataSet

protocol DeleteProtocol {
    func deleteHistory()
}

internal final class LunchHistoryViewController: UIViewController, HeaderViewDisplayable, DeleteProtocol {
    
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
        tableView.emptyDataSetSource = self
        tableView.register(StoreInfoTableCell.self)
        historyList = HistoryManager.shared.historyListDataFromRealm()
    }
    
    // MARK: - IBAction
    
    func deleteHistory() {
        historyList = HistoryManager.shared.historyListDataFromRealm()
        tableView.reloadData()
    }
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
        if let store = historyList[indexPath.section].store {
            cell.setup(store: store, dateString: historyList[indexPath.section].date, delegate: self)
        } else {
            cell.setupUnknownStore(genre: historyList[indexPath.section].genre, dateString: historyList[indexPath.section].date, delegate: self)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension LunchHistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableHeaderView.instantiate(owner: self, title: historyList[section].date)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let store = historyList[indexPath.row].store else {
            return
        }
        AlertController.showAlert(title: "確認", message: "\(store.name) の詳細ページへ遷移してもよろしいですか？", positiveAction: {
            if let url = URL(string: store.url), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        })
    }
}

// MARK: - DZNEmptyDataSet

extension LunchHistoryViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "表示できるデータがありません"
        let font = UIFont.systemFont(ofSize: 16)
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: DeviceModel.themeColor.color]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

// MARK: - ScreenReloadable

extension LunchHistoryViewController: ScreenReloadable {
    func reloadScreen() {
        view.layoutUpdableViews.forEach { $0.refreshLayout() }
        tableView.reloadData()
    }
}
