//
//  MAnimatedTableViewCell.swift
//  Master
//
//  Created by Carlos Mejía on 21/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class MAnimatedTableViewCell: UITableViewCell {
    private let animationTime: TimeInterval = 0.2
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: animationTime) {
            self.alpha = 0.5
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: animationTime) {
            self.alpha = 1
        }
    }
}
