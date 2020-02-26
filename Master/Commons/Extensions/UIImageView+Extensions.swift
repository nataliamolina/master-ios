//
//  UIImageView+Extensions.swift
//  Master
//
//  Created by Carlos Mejía on 25/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

extension UIImageView {
    override open func awakeFromNib() {
        super.awakeFromNib()
        tintColorDidChange()
    }
}
