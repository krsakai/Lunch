//
//  StoreSearchViewController.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/21.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

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
        tableView.emptyDataSetSource = self
        tableView.register(StoreInfoTableCell.self)
        showLoading()
        StoreManager.shared.searchStoreListDataFromLocation(isForceCurrent: true).success { storeList in
            self.hideLoading()
            self.currentLocationStoreList = storeList
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(openKeyboardTap), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    @objc func hideKeyboardTap() {
        view.endEditing(true)
        if let gestures = view.gestureRecognizers {
            gestures.forEach { gesture in
                if gesture.isKind(of: UITapGestureRecognizer.self) {
                    view.removeGestureRecognizer(gesture)
                }
            }
        }
    }
    
    @objc func openKeyboardTap() {
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(hideTap)
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
        cell.setup(store: storeList[indexPath.section][indexPath.row], isRegistMode: true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store = self.storeList[indexPath.section][indexPath.row]
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

extension StoreSearchViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "表示できるデータがありません"
        let font = UIFont.systemFont(ofSize: 16)
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: DeviceModel.themeColor.color]
        return NSAttributedString(string: text, attributes: attributes)
    }
}


// MARK: - UISearchBarDelegate

extension StoreSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else {
            return
        }
        showLoading()
        StoreManager.shared.searchStoreListDataFromLocation(condition: .keyword(keyword)).success { storeList in
            self.hideLoading()
            self.searchStoreList = storeList
            self.searchType = .keyword(keyword)
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
        }.then { _, _ in
            self.hideLoading()
        }
        self.tableView.scrollToFirstPosition()
    }
}

// MARK: - ScreenReloadable

extension StoreSearchViewController: ScreenReloadable {
    func reloadScreen() {
        view.layoutUpdableViews.forEach { $0.refreshLayout() }
        tableView.reloadData()
    }
}

internal final class GenreSelectButton: UIButton {
    
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
    
    func scrollToFirstPosition() {
        self.setContentOffset(CGPoint(x: 0, y: -self.contentInset.top), animated: false)
    }
}
