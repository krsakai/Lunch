//
//  StoreInfoTableCell.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/22.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit
import AlamofireImage
import TTTAttributedLabel

internal final class StoreInfoTableCell: UITableViewCell, NibRegistrable {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var storeImageView: UIImageView!
    @IBOutlet private weak var storeNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: WeakLabel!
    @IBOutlet private weak var businessDateLabel: WeakLabel!
    @IBOutlet private weak var genreView: UIView!
    @IBOutlet private weak var genreLabel: TTTAttributedLabel!
    @IBOutlet private weak var doneButton: ThemeButton!
    
    
    // MARK: - Initialzer
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.genreLabel.verticalAlignment = .center
        let angle = CGFloat(Double.pi / 2)
        self.genreLabel.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    // MARK: - Property
    
    private var store: Store?
    
    func setup(store: Store, isRegistMode: Bool = false) {
        self.store = store
        let url = URL(string: store.imageUrl)!
        storeImageView.af_setImage(withURL: url, placeholderImage: R.image.noImage())
        storeNameLabel.text = store.name
        addressLabel.text = store.address
        businessDateLabel.text = store.open + " " + store.close
        let genre = GenreManager.shared.genreDataFromRealm(predicate: Genre.predicate(code: store.genreCode))
        genreLabel.setText(genre.name) { text in
            let textLength = text?.length ?? 0
            CFAttributedStringSetAttribute(text, CFRangeMake(0, textLength), kCTForegroundColorAttributeName, genre.textColor as CFTypeRef)
            CFAttributedStringSetAttribute(text, CFRangeMake(0, textLength), kCTVerticalFormsAttributeName, true as CFTypeRef)
            return text
        }
        genreView.backgroundColor = genre.color
        doneButton.isHidden = DeviceModel.isOverLunch || !isRegistMode
    }
    
    // MARK: - IBAction
    
    @IBAction private func didTapDetailButton(_ sender: Any) {
        guard let store = store else {
            return
        }
        let viewController = StoreDetailViewController.instantiate(store: store)
        AppDelegate.navigation?.pushViewController(viewController, animated: true)
    }
    
    @IBAction private func didTapMapButton(_ sender: Any) {
        guard let store = store else {
            return
        }
        let viewController = MapViewController.instantiate(store: store)
        AppDelegate.navigation?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        guard let store = store else {
            return
        }
        let genre = GenreManager.shared.genreDataFromRealm(predicate: Genre.predicate(code: store.genreCode))
        let alertMessage = AlertMessage(title: genre.name, message: store.name + " で決定してもよろしいですか？")
        let alertType = AlertType.info(message: alertMessage)
        let doneButton = AlertButton(label: "OK") {
            let history = History(store: store, genre: genre)
            if HistoryManager.shared.canRegistHistory(history) {
                HistoryManager.shared.saveHistoryToRealm(history)
                let viewController = LunchHistoryViewController.instantiate()
                AppDelegate.navigation?.setViewControllers([viewController], animated: false)
            } else {
                AlertController.showAlert(title: "重複登録", message: "既に本日はお昼を登録済みです。履歴をご確認ください", enableCancel: false)
            }
        }
        let retryButton = AlertButton(label: "選び直す") {}
        
        AlertController.shared.show(alertType: alertType, buttonList: [doneButton, retryButton])
    }
    
}
