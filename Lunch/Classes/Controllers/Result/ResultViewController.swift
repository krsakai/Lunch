//
//  ResultViewController.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/28.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit

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
        tableView.register(StoreInfoTableCell.self)
        StoreManager.shared.searchStoreListDataFromLocation(condition: .genre(genre)).success { storeList in
            self.storeList = storeList
            self.tableView.reloadData()
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
}

// MARK: - ScreenReloadable

extension ResultViewController: ScreenReloadable {
    func reloadScreen() {
        view.layoutUpdableViews.forEach { $0.refreshLayout() }
        tableView.reloadData()
    }
}
