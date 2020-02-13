//
//  MLegalButton.swift
//  Master
//
//  Created by Carlos Mejía on 10/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class MLegalButton: UIButton {
    @IBInspectable var localizableKey: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupStlye()
    }
    
    // MARK: - Private Methods
    private func setupStlye() {
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 2
        titleLabel?.lineBreakMode = .byWordWrapping
        
        let text = localizableKey.localized
        let titleString = NSMutableAttributedString(string: text)
        titleString.addAttribute(NSAttributedString.Key.underlineStyle,
                                 value: NSUnderlineStyle.single.rawValue,
                                 range: NSMakeRange(0, text.count))
        
        setAttributedTitle(titleString, for: .normal)
    }
}
