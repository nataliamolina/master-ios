//
//  UIButton+Extensions.swift
//  Master
//
//  Created by Carlos Mejía on 2/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {

    var title: String? {
        get { return titleLabel?.text ?? "" }
        set(newValue) {
            let states: [UIControl.State] = [.normal, .highlighted, .selected, .disabled]
            
            states.forEach { state in
                setTitle(newValue, for: state)
            }
        }
    }
}
