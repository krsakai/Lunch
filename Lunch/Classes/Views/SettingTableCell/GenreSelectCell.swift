//
//  GenreSelectCell.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/27.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit

internal final class GenreSelectCell: UITableViewCell {
    
    static func instantiate(_ owner: AnyObject) -> GenreSelectCell {
        let cell = R.nib.genreSelectCell.firstView(owner: owner, options: nil)!
        return cell
    }
    
    @IBAction func genreSelectButtonTapped(_ sender: Any) {
        let viewController = GenreSettingViewController.instantiate()
        AppDelegate.topViewController?.present(viewController, animated: true, completion: nil)
    }
}
