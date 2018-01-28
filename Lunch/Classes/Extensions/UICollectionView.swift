//
//  UICollectionView.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/28.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register<T: Registrable>(_ registrableType: T.Type) where T: UICollectionViewCell {
        switch registrableType {
        case let nibRegistrableType as NibRegistrable.Type:
            register(nibRegistrableType.nib, forCellWithReuseIdentifier: nibRegistrableType.reuseIdentifier)
        case let classRegistrableType as ClassRegistrable.Type:
            register(classRegistrableType, forCellWithReuseIdentifier: classRegistrableType.reuseIdentifier)
        default:
            assertionFailure("\(registrableType) is unknown type")
        }
    }
    
    func dequeueReusableCell<T: Registrable>(for indexPath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with type \(T.self)")
        }
        return cell
    }
}
