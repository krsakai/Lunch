//
//  SplashViewController.swift
//  Lunch
//
//  Created by 酒井邦也 on 2017/04/03.
//  Copyright © 2017年 酒井邦也. All rights reserved.
//

import UIKit
import SwiftTask

internal final class SplashViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var splashMain: UIImageView!
    
    // MARK: Property
    
    // MARK: Initilizer
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        // 初期化.
        splashMain.transform = CGAffineTransform(rotationAngle: 0)
        // アニメーションの秒数を設定.
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.splashMain.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                self.splashMain.transform = CGAffineTransform.identity
            }, completion: { _ in
                AppDelegate.sideMenu?.changeContentViewController()
            })
        })
    }
}
