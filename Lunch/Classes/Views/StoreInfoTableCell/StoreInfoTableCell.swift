//
//  StoreInfoTableCell.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/22.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit
import AlamofireImage

internal final class StoreInfoTableCell: UITableViewCell, NibRegistrable {
    
    // MARK: IBOutlet
    @IBOutlet private weak var storeImageView: UIImageView!
    @IBOutlet private weak var storeNameLabel: UILabel!
    @IBOutlet private weak var addressLabel: WeakLabel!
    @IBOutlet private weak var businessDateLabel: WeakLabel!
    
    // MARK: Property
    private var store: Store? {
        didSet {
            guard let store = store else {
                return
            }
            let url = URL(string: store.imageUrl)!
            storeImageView.af_setImage(withURL: url, placeholderImage: R.image.noImage())
            storeNameLabel.text = store.name
            addressLabel.text = store.address
            businessDateLabel.text = store.open + " " + store.close
        }
    }
    
    func setup(store: Store) {
        self.store = store
    }
    
    // MARK: IBAction
    @IBAction private func didTapDetailButton(_ sender: Any) {
        guard let store = store else {
            return
        }
        let viewController = StoreDetailViewController.instantiate(store: store)
        AppDelegate.navigation?.pushViewController(viewController, animated: true)
    }
    
    @IBAction private func didTapMapButton(_ sender: Any) {
        
    }
    
}
