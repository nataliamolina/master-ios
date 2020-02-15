//
//  MLegalButton.swift
//  Master
//
//  Created by Carlos Mejía on 10/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class MLegalButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStlye()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupStlye()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupStlye()
    }
    
    // MARK: - Private Methods
    private func setupStlye() {
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 2
        titleLabel?.lineBreakMode = .byWordWrapping
        
        let text = "general.legal.continue".localized
        setTitle(text, for: .normal)
        let titleString = NSMutableAttributedString(string: text)
        titleString.addAttribute(NSAttributedString.Key.underlineStyle,
                                 value: NSUnderlineStyle.single.rawValue,
                                 range: NSRange(location: 0, length: text.count))
        
        setAttributedTitle(titleString, for: .normal)
    }
}
