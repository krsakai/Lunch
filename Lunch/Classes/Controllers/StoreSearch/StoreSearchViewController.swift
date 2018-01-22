//
//  StoreSearchViewController.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/21.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit

internal final class StoreSearchViewController: UIViewController, HeaderViewDisplayable {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    // MARK: - Property
    fileprivate var searchStoreList: [Store] = []
    fileprivate var currentLocationStoreList: [Store] = []
    fileprivate var storeList: [[Store]] {
        return [searchStoreList, currentLocationStoreList]
    }
    
    // MARK: - Initializer
    
    static func instantiate() -> StoreSearchViewController {
        return R.storyboard.storeSearchViewController.storeSearchViewController()!
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView("お店検索", headerItems: HeaderItems([.sideMenu], nil))
        tableView.register(StoreInfoTableCell.self)
        StoreManager.shared.searchStoreListDataFromCurrentLocation.success { storeList in
            self.currentLocationStoreList = storeList
            self.tableView.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - IBAction
    
}

extension StoreSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeList[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return storeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as StoreInfoTableCell
        cell.setup(store: storeList[indexPath.section][indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension StoreSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableHeaderView.instantiate(owner: self, title: ["検索したお店", "現在地周辺のお店"][section])
    }
}

// MARK: - UISearchBarDelegate

extension StoreSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else {
            return
        }
        StoreManager.shared.searchStoreListData(apiInfo: .searchStoreFromKeyword(keyword: keyword)).success { storeList in
            self.searchStoreList = storeList
            self.tableView.reloadData()
            
        }
        self.tableView.scrollToFirstPosition()
        view.endEditing(true)
    }
}

extension UITableView {
    // FIXME: カスタムクラス作ったほうがいい
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
    
    func scrollToFirstPosition() {
        self.setContentOffset(CGPoint(x: 0, y: -self.contentInset.top), animated: false)
    }
}
