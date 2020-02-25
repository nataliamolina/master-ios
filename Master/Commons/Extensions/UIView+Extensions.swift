//
//  UIView+Extensions.swift
//  Master
//
//  Created by Carlos Mejía on 21/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        let nibReference = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first
        
        guard let customView = nibReference as? T else {
            fatalError("Unable to load Xib from \(String(describing: T.self))")
        }
        
        return customView
    }
    
    func addConstraintsToFit(view: UIView, space: Int? = 0) {
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(space ?? 0))-[view]-(\(space ?? 0))-|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["view": view])
        addConstraints(verticalConstraints)
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(space ?? 0))-[view]-(\(space ?? 0))-|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["view": view])
        addConstraints(horizontalConstraints)
    }
}
