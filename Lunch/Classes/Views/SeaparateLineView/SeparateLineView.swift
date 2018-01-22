//
//  SeparateLineView.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/22.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit

internal final class SeapateLineView: UIView {
    // MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let contentView = R.nib.underLineView.firstView(owner: self, options: nil)!
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.right.left.bottom.top.equalTo(0)
        }
        contentView.backgroundColor = LunchColor.Line.separator
    }
}
