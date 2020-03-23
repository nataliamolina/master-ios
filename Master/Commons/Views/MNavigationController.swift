//
//  MNavigationController.swift
//  Master
//
//  Created by Carlos Mejía on 23/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import UIKit
import Hero

class MNavigationController: UINavigationController {

    init() {
        super.init(rootViewController: UIViewController())
        
        commonSetup()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        commonSetup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonSetup()
    }
    
    private func commonSetup() {
        navigationBar.tintColor = UIColor.Master.green
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.prefersLargeTitles = true
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = .clear
        navigationBar.barTintColor = .white
        navigationBar.isTranslucent = true
    }
}
