//
//  MButton.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit

enum MButtonType {
    case whiteBorder
    case greenBorder
    case white
    case green
    case onlyWhiteText
}

class MButton: UIButton {
    
    var style: MButtonType = .greenBorder {
        didSet {
           setupStyle()
        }
    }
    
    func setupStyle() {
        guard let selectedStyle: ButtonStyleConfig = Styles.buttonStyles[style] else {
            return
        }
        
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        backgroundColor = selectedStyle.bg
        setTitleColor(selectedStyle.text, for: .normal)
        
        layer.borderWidth = 1.5
        layer.borderColor = selectedStyle.border.cgColor
        layer.cornerRadius = 24
    }
}
