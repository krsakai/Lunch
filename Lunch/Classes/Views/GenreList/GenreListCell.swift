//
//  GenreListCell.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/27.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit
import CTCheckbox

internal final class GenreListCell: UITableViewCell, NibRegistrable {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var genreName: UILabel!
    
    // MARK: - Property
    private var checkbox: CTCheckbox!
    private var genre: Genre!
    
    // MARK: - Initialzer
    override func awakeFromNib() {
        super.awakeFromNib()
        // Notice: StoryBoard使えない SnapKit効かない
        let size: CGFloat = 50.0
        let x: CGFloat = frame.width - 5 - size
        let y: CGFloat = center.y - size / 2
        self.checkbox = CTCheckbox(frame: CGRect(x: x, y: y, width: size, height: size))
        self.checkbox?.checkboxSideLength = 30
        self.checkbox.setColor(DeviceModel.themeColor.color, for: .normal)
        self.checkbox.setColor(DeviceModel.themeColor.color, for: .highlighted)
        self.checkbox.addTarget(self, action: #selector(GenreListCell.changeCheckbox(checkbox:)), for: .valueChanged)
        contentView.addSubview(checkbox)
        layoutIfNeeded()
    }
    
    func setup(genre: Genre) {
        self.genre = genre
        genreName.text = genre.name
        checkbox.checked = genre.isActive
    }
    
    func toggleCheckBox() {
        let genreClone = genre.clone
        genreClone.isActive = !checkbox.checked
        checkbox.checked = genreClone.isActive
        GenreManager.shared.saveGenreListToRealm([genreClone])
    }
    
    @objc func changeCheckbox(checkbox: CTCheckbox) {
        let genreClone = genre.clone
        genreClone.isActive = checkbox.checked
        GenreManager.shared.saveGenreListToRealm([genreClone])
    }
}
