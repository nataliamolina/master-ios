//
//  Master.swift
//  Master
//
//  Created by Carlos Mejía on 23/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import UIKit

class Master {
    static func setRootVC(viewController: UIViewController) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        
        window.rootViewController = viewController
        
        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
    }
    
    static var rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    static func setRootVC(navigationController: UINavigationController) {
        setRootVC(viewController: navigationController)
    }
}
