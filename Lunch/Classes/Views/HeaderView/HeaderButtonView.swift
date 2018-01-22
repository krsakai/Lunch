//
//  HeaderButtonView.swift
//  Lunch
//
//  Created by 酒井邦也 on 2017/03/10.
//  Copyright © 2017年 酒井邦也. All rights reserved.
//

import UIKit

internal final class HeaderButtonView: UIView {
    
    @IBOutlet weak var headerButton: UIButton!
    
    private(set) var buttonType: HeaderButtonType = .sideMenu
    private var delegate: HeaderViewDisplayable?
    
    static func instantiate(owner: HeaderViewDisplayable, buttonType: HeaderButtonType) -> HeaderButtonView {
        let buttonView = R.nib.headerButtonView.firstView(owner: owner as AnyObject, options: nil)!
        buttonView.delegate = owner
        buttonView.buttonType = buttonType
        buttonView.headerButton.setImage(buttonType.image, for: .normal)
        buttonView.headerButton.setImage(buttonType.selectedImage, for: .highlighted)
        buttonView.headerButton.setTitle(buttonType.title, for: .normal)
        buttonView.headerButton.setTitle(buttonType.title, for: .highlighted)
        buttonView.headerButton.titleLabel?.font = buttonType.titleFont
        buttonView.headerButton.tintColor = buttonType.tintColor
        return buttonView
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        delegate?.didTapHeaderButton(buttonType: buttonType)
    }
    
    func updateButton(enabled: Bool) {
        headerButton.isEnabled = enabled
    }
}
