//
//  SearchPlaceTableCell.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/02/03.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit
import HSegmentControl

internal enum Place: String {
    case current = "現在地"
    case custom = "カスタム"
    
    var title: String {
        switch self {
        case .current:
            return rawValue
        case .custom:
            if let location = DeviceModel.customLocation {
                return location.name
            } else {
                return rawValue
            }
        }
    }
}

internal final class SearchPlaceTableCell: UITableViewCell {
    
    @IBOutlet private weak var segmentControl: HSegmentControl!
    
    fileprivate var searchPlaceList: [Place] {
        return [.current, .custom]
    }
    
    static func instantiate(_ owner: AnyObject) -> SearchPlaceTableCell {
        let cell = R.nib.searchPlaceTableCell.firstView(owner: owner, options: nil)!
        cell.segmentControl.dataSource = cell
        cell.segmentControl.numberOfDisplayedSegments = cell.searchPlaceList.count
        cell.segmentControl.selectedTitleFont = UIFont.systemFont(ofSize: 14)
        cell.segmentControl.selectedTitleColor = UIColor.white
        cell.segmentControl.unselectedTitleFont = UIFont.systemFont(ofSize: 14)
        cell.segmentControl.unselectedTitleColor = UIColor.gray
        cell.segmentControl.segmentIndicatorView.backgroundColor = DeviceModel.themeColor.color
        cell.segmentControl.selectedIndex = DeviceModel.customLocation == nil ? 0 : 1
        return cell
    }
    
    @IBAction func valueChanged(segmentControl: HSegmentControl) {
        guard segmentControl.selectedIndex == 1 else {
            DeviceModel.customLocation = nil
            AppDelegate.reloadScreen()
            return
        }
        let alertMessage = AlertMessage(title: "検索場所の設定", message: "検索場所を入力してください")
        let alertType = AlertType.info(message: alertMessage)
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 216, height: 25))
        textField.returnKeyType = .done
        textField.delegate = self
        let buttonList = [
            AlertButton(label: "設定する") {
                guard let text = textField.text, !text.isEmpty else {
                    return
                }
                LoadingController.shared.show(title: "検索中")
                let apiInfo = ApiInfo.geocoding(keyword: text)
                ApiManager(apiInfo: apiInfo).request(success: { (locationList: [Location])  in
                    guard let location = locationList.first else {
                        LoadingController.shared.hide() {
                            AlertController.showAlert(title: "検索エラー", message: "検索した位置情報が取得できませんでした", enableCancel: false)
                        }
                        return
                    }
                    DeviceModel.customLocation = location
                    LoadingController.shared.hide() {
                        AppDelegate.reloadScreen()
                    }
                }, fail: { error in
                    LoadingController.shared.hide() {
                        AlertController.showAlert(title: "検索エラー", message: "検索した位置情報が取得できませんでした", enableCancel: false)
                    }
                    AppDelegate.reloadScreen()
                })
            }, AlertButton(label: "キャンセル") {
                AppDelegate.reloadScreen()
            }]
        AlertController.shared.show(alertType: alertType, buttonList: buttonList, textFiled: textField)
    }
}

extension SearchPlaceTableCell: HSegmentControlDataSource {
    
    func numberOfSegments(_ segmentControl: HSegmentControl) -> Int {
        return searchPlaceList.count
    }
    
    func segmentControl(_ segmentControl: HSegmentControl, titleOfIndex index: Int) -> String {
        return searchPlaceList[index].title
    }
}

extension SearchPlaceTableCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
