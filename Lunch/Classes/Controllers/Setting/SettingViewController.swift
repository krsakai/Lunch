////
////  SettingViewController.swift
////  Lunch
////
////  Created by 酒井邦也 on 2017/03/28.
////  Copyright © 2017年 酒井邦也. All rights reserved.
////

import UIKit
import GoogleMobileAds

internal enum Setting {
    case genreSelect
    case searchPlace
    case searchRange
    case themeColor
    case howToUse
    case copyright
    
    var title: String {
        switch self {
        case .genreSelect: return "ジャンル設定"
        case .searchPlace: return "検索場所"
        case .searchRange: return "検索範囲 (半径)"
        case .themeColor: return "テーマ色選択"
        case .howToUse: return "使い方"
        case .copyright: return "情報提供元"
        }
    }
    
    func cell(owner: AnyObject) -> UITableViewCell {
        switch self {
        case .genreSelect: return GenreSelectCell.instantiate(owner)
        case .searchPlace: return SearchPlaceTableCell.instantiate(owner)
        case .searchRange: return SearchRangeTableCell.instantiate(owner)
        case .themeColor: return ThemeColorSelectCell.instantiate(owner)
        case .howToUse: return HowToUseTableCell.instantiate(owner)
        case .copyright:
            let cell = UITableViewCell()
            cell.textLabel?.text = " ホットペッパーグルメ"
            return cell
        }
    }
}

internal final class SettingViewController: UIViewController, HeaderViewDisplayable  {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet private weak var bannerView: GADBannerView!
    
    
    fileprivate var settingList: [[Setting]] {
        return [[.genreSelect], [.searchPlace], [.searchRange], [.themeColor], [.howToUse], [.copyright]]
    }
    
    // MARK: - Initializer
    
    static func instantiate() -> SettingViewController {
        let viewController = R.storyboard.settingViewController.settingViewController()!
        return viewController
    }

    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView("設定", headerItems: HeaderItems(leftItems: [.close], rightItems: nil))
        
        bannerView.adUnitID = AdType.banner.adId
        bannerView.rootViewController = self
        let request = GADRequest()
        #if DEBUG
            request.testDevices = [kGADSimulatorID]
        #endif
        bannerView.load(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let request = GADRequest()
        #if DEBUG
            request.testDevices = [kGADSimulatorID]
        #endif
        bannerView.load(request)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingList[section][0].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return settingList[indexPath.section][indexPath.row].cell(owner: tableView)
    }
}

extension SettingViewController: ScreenReloadable {
    func reloadScreen() {
        headerView.refreshLayout()
        tableView.reloadData()
    }
}
