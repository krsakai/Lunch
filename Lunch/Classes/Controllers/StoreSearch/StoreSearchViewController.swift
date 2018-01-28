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
    @IBOutlet private weak var tableView: IgnoreTouchTableView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var footerView: FooterView!
    
    
    // MARK: - Property
    fileprivate var searchStoreList: [Store] = []
    fileprivate var currentLocationStoreList: [Store] = []
    fileprivate var storeList: [[Store]] {
        return [searchStoreList, currentLocationStoreList]
    }
    
    internal enum StoreSearchType {
        case keyword(String)
        case genre(Genre)
    }
    var searchType: StoreSearchType?
    
    // MARK: - Initializer
    
    static func instantiate() -> StoreSearchViewController {
        return R.storyboard.storeSearchViewController.storeSearchViewController()!
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView("お店検索", headerItems: HeaderItems([.sideMenu], nil))
        tableView.register(StoreInfoTableCell.self)
        showLoading()
        StoreManager.shared.searchStoreListDataFromLocation().success { storeList in
            self.hideLoading()
            self.currentLocationStoreList = storeList
            self.tableView.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - IBAction
    
    @IBAction func genreSelectButtonTapped(_ sender: Any) {
        let viewController = GenreSelectViewController.instantiate() { genre in
            self.tableView.scrollToFirstPosition()
            self.showLoading()
            StoreManager.shared.searchStoreListDataFromLocation(condition: .genre(genre)).success { storeList in
                self.hideLoading()
                self.searchStoreList = storeList
                self.searchType = .genre(genre)
                self.tableView.reloadData()
            }
        }
        present(viewController, animated: true, completion: nil)
    }
    
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
        var searchStoreString = ""
        if let searchType = searchType {
            switch searchType {
            case .keyword(let keyword):
                searchStoreString.append("キーワード検索：\(keyword)")
            case .genre(let genre):
                searchStoreString.append("ジャンル検索：\(genre.name)")
            }
        } else {
            searchStoreString.append("検索したお店")
        }
        return TableHeaderView.instantiate(owner: self, title: [searchStoreString, "現在地周辺のお店"][section])
    }
}

// MARK: - UISearchBarDelegate

extension StoreSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else {
            return
        }
        StoreManager.shared.searchStoreListDataFromLocation(condition: .keyword(keyword)).success { storeList in
            self.searchStoreList = storeList
            self.searchType = .keyword(keyword)
            self.tableView.reloadData()
        }
        self.tableView.scrollToFirstPosition()
        view.endEditing(true)
    }
}

// MARK: - ScreenReloadable

extension StoreSearchViewController: ScreenReloadable {
    func reloadScreen() {
        view.layoutUpdableViews.forEach { $0.refreshLayout() }
        tableView.reloadData()
    }
}

internal final class GenreSelectButton: 
UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1.0
        layer.borderColor = DeviceModel.themeColor.color.cgColor
        layer.cornerRadius = 8.0
        setTitleColor(DeviceModel.themeColor.color, for: .normal)
        setTitleColor(DeviceModel.themeColor.color, for: .highlighted)
    }
}

internal final class IgnoreTouchTableView: UITableView {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
    
    func scrollToFirstPosition() {
        self.setContentOffset(CGPoint(x: 0, y: -self.contentInset.top), animated: false)
    }
}
