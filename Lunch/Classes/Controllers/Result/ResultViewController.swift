//
//  ResultViewController.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/28.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

internal final class ResultViewController: UIViewController, HeaderViewDisplayable {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var footerView: FooterView!
    
    // MARK: - Property
    fileprivate var storeList: [Store]  = []
    fileprivate var genre: Genre!
    
    // MARK: - Initializer
    
    static func instantiate(genre: Genre) -> ResultViewController {
        let viewController = R.storyboard.resultViewController.resultViewController()!
        viewController.genre = genre
        return viewController
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView("お店候補", headerItems: HeaderItems([.back], nil))
        tableView.emptyDataSetSource = self
        tableView.register(StoreInfoTableCell.self)
        showLoading()
        StoreManager.shared.searchStoreListDataFromLocation(condition: .genre(genre)).success { storeList in
            self.hideLoading()
            self.storeList = storeList
            self.tableView.reloadData()
        }.failure { error in
            guard let error = error.error else {
                return
            }
            let alertMessage = AlertMessage(title: error.title, message: error.message)
            let alertType = AlertType.error(message: alertMessage)
            let buttonList = [AlertButton(label: "OK") { }]
            self.hideLoading() {
                self.showAlert(alertType: alertType, buttonList: buttonList)
            }
        }
    }
    
    // MARK: - IBAction
    
}

extension ResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as StoreInfoTableCell
        cell.setup(store: storeList[indexPath.row], isRegistMode: true)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableHeaderView.instantiate(owner: self, title: "絞り込みジャンル：" + genre.name)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = StoreDetailViewController.instantiate(store: storeList[indexPath.row])
        AppDelegate.navigation?.pushViewController(viewController, animated: true)
    }
}


// MARK: - DZNEmptyDataSet

extension ResultViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "表示できるデータがありません"
        let font = UIFont.systemFont(ofSize: 16)
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: DeviceModel.themeColor.color]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

// MARK: - ScreenReloadable

extension ResultViewController: ScreenReloadable {
    func reloadScreen() {
        view.layoutUpdableViews.forEach { $0.refreshLayout() }
        tableView.reloadData()
    }
}
