//
//  LunchLotteryViewController.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/21.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import GoogleMobileAds

internal final class LunchLotteryViewController: UIViewController, HeaderViewDisplayable {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var completionLunchView: UIView!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    // MARK: - Property
    
    fileprivate var genreList: [Genre] = [] {
        didSet {
            randomButton.isEnabled = !genreList.isEmpty
            randomButton.alpha = genreList.isEmpty ? 0.3 : 1.0
        }
    }
    
    // MARK: - Initializer
    
    static func instantiate() -> LunchLotteryViewController {
        return R.storyboard.lunchLotteryViewController.lunchLotteryViewController()!
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let headerItems = HeaderItems(leftItems: [.sideMenu], rightItems: nil)
        setupHeaderView("今日のお昼", headerItems: headerItems)
        genreList = GenreManager.shared.genreListDataFromRealm(predicate: Genre.predicate(isActive: true))
        completionLunchView.isHidden = !DeviceModel.isOverLunch
        collectionView.emptyDataSetSource = self
        
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
    
    // MARK: - IBAction
    
    @IBAction func genreEditButtonTapped(_ sender: Any) {
        
        let viewController = GenreSettingViewController.instantiate() {
            self.genreList = GenreManager.shared.genreListDataFromRealm(predicate: Genre.predicate(isActive: true))
            self.collectionView.reloadData()
        }
        AppDelegate.topViewController?.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapRandomButton(_ sender: Any) {
        guard !genreList.isEmpty else {
            return
        }
        let genre = genreList.randomItem
        let alertMessage = AlertMessage(title: genre.name, message: "このジャンルでよろしいですか？")
        let alertType = AlertType.info(message: alertMessage)
        var buttonList = [AlertButton(label: "このジャンルでお店を検索する") {
            let viewController = ResultViewController.instantiate(genre: genre)
            AppDelegate.navigation?.pushViewController(viewController, animated: true)
        }]
        if !DeviceModel.isOverLunch {
            buttonList.append(AlertButton(label: "お店は歩いて探す") {
                HistoryManager.shared.saveHistoryToRealm(History(genre: genre))
                let viewController = LunchHistoryViewController.instantiate()
                AppDelegate.navigation?.setViewControllers([viewController], animated: false)
            })
        }
        buttonList.append(AlertButton(label: "選び直す"){})
        AlertController.shared.show(alertType: alertType, buttonList: buttonList)
    }
    
}

extension LunchLotteryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath as IndexPath) as GenreListCollectionCell
        cell.update(genre: genreList[indexPath.row])
        return cell
    }
}

extension LunchLotteryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let viewController = ResultViewController.instantiate(genre: genreList[indexPath.row])
        AppDelegate.navigation?.pushViewController(viewController, animated: true)
    }
}

// MARK: - DZNEmptyDataSet

extension LunchLotteryViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "表示できるデータがありません"
        let font = UIFont.systemFont(ofSize: 16)
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: DeviceModel.themeColor.color]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

// MARK: - ScreenReloadable

extension LunchLotteryViewController: ScreenReloadable {
    func reloadScreen() {
        view.layoutUpdableViews.forEach { $0.refreshLayout() }
        stackView.layoutUpdableViews.forEach { $0.refreshLayout() }
        genreList = GenreManager.shared.genreListDataFromRealm(predicate: Genre.predicate(isActive: true))
        collectionView.reloadData()
    }
}
