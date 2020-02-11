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

@IBDesignable class MButton: UIButton {
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupStyle()
    }
    
    // MARK: - Properties
    var style: MButtonType = .greenBorder {
        didSet {
            setupStyle()
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            animateState()
        }
    }
    
    // MARK: - Private Methods
    private func setupStyle() {
        animateState()
        
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
    
    private func animateState() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = self.isEnabled ? 1.0 : 0.5
        }
    }
}
