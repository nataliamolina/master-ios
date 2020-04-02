//
//  MTextView.swift
//  Master
//
//  Created by Carlos Mejía on 2/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class MTextView: UITextView {
    // MARK: - Properties
    private var bottomLine = UIView()
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupStlye()
    }
    
    // MARK: - Public Methods
    func updateBottomLine() {
        let borderFrame = CGRect(x: frame.origin.x,
                                 y: frame.origin.y + frame.height,
                                 width: frame.width,
                                 height: 1)
        
        bottomLine.frame = borderFrame
    }
    
    // MARK: - Private Methods
    private func setupStlye() {
        bottomLine.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let borderFrame = CGRect(x: frame.origin.x,
                                 y: frame.origin.y + frame.height,
                                 width: frame.width,
                                 height: 1)
        
        bottomLine.frame = borderFrame
        bottomLine.backgroundColor = UIColor.Master.green
        
        superview?.insertSubview(bottomLine, aboveSubview: self)
    }
}
