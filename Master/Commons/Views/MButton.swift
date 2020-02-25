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
    private let touchAnimationTime: TimeInterval = 0.2
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: touchAnimationTime) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: touchAnimationTime) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    // MARK: - UI Referneces
    @IBInspectable var styleId: Int = 1 {
        didSet {
            setupStyleId()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 24 {
        didSet {
            setupStyleId()
        }
    }
    
    // MARK: - Properties
    var style: MButtonType? {
        didSet {
            setupStyle(style: self.style ?? .greenBorder)
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            animateState()
        }
    }
    
    // MARK: - Private Methods
    private func setupStyleId() {
        if let styleSelected = MButtonType(rawValue: styleId) {
            setupStyle(style: styleSelected)
        }
    }
    
    private func setupStyle(style: MButtonType) {
        animateState()
        
        guard let selectedStyle: ButtonStyleConfig = Styles.buttonStyles[style] else {
            return
        }
        
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        backgroundColor = selectedStyle.bg
        setTitleColor(selectedStyle.text, for: .normal)
        
        layer.borderWidth = 1.5
        layer.borderColor = selectedStyle.border.cgColor
        layer.cornerRadius = cornerRadius
    }
    
    private func animateState() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = self.isEnabled ? 1.0 : 0.5
        }
    }
}
