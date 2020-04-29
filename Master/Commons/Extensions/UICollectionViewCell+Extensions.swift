//
//  UICollectionViewCell+Extensions.swift
//  Master
//
//  Created by Carlos Mejía on 27/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}
