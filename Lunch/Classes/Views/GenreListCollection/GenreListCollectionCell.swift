//
//  GenreListCollectionCell.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/28.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit

internal final class GenreListCollectionCell: UICollectionViewCell, ClassRegistrable {
    @IBOutlet private weak var genreName: UILabel!
    
    func update(genre: Genre) {
        contentView.backgroundColor = genre.color
        genreName.text = genre.name
        genreName.textColor = genre.textColor
    }
}
