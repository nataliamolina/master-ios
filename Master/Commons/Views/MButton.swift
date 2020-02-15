//
//  MButton.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit

enum MButtonType: Int {
    case whiteBorder
    case greenBorder
    case white
    case green
    case onlyWhiteText
}

class MButton: UIButton {
    // MARK: - UI Referneces
    @IBInspectable var styleId: Int = 1
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupStyleId()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyleId()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupStyleId()
    }
    
    // MARK: - Properties
    var style: MButtonType = .greenBorder
    
    override open var isEnabled: Bool {
        didSet {
            animateState()
        }
    }
    
    // MARK: - Private Methods
    private func setupStyleId() {
        guard let styleSelected = MButtonType(rawValue: styleId) else {
            return
        }
        
        style = styleSelected
        setupStyle()
    }
    
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
