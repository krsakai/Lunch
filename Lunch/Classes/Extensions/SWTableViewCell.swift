//
//  SWTableViewCell.swift
//  Lunch
//
//  Created by 酒井邦也 on 2017/03/28.
//  Copyright © 2017年 酒井邦也. All rights reserved.
//

import Foundation
import RealmSwift
import SWTableViewCell

protocol OperableCell {
    var entity: Object? { get }
}

extension SWTableViewCell: OperableCell {
    @objc var entity: Object? {
        return nil
    }
}
