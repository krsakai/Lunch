//
//  HowToUseTableCell.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/29.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit

internal final class HowToUseTableCell: UITableViewCell {
    
    static func instantiate(_ owner: AnyObject) -> HowToUseTableCell {
        let cell = R.nib.howToUseTableCell.firstView(owner: owner, options: nil)!
        return cell
    }
    
    @IBAction func howToUseButtonTapped(_ sender: Any) {
        let viewController = R.storyboard.howToUseViewController.howToUseViewController()!
        AppDelegate.topViewController?.present(viewController, animated: true, completion: nil)
    }
}

