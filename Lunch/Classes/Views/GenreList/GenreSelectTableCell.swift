//
//  GenreSelectTableCell.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/29.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit

internal final class GenreSelectTableCell: UITableViewCell, NibRegistrable {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var genreName: UILabel!
    
    // MARK: - Property
    
    // MARK: - Initialzer
    
    func setup(genre: Genre) {
        genreName.text = genre.name
    }
}

