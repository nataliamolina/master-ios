//
//  SplashScreenViewController.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit

class SplashScreenViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO: Use routers!
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = UIColor.Master.green
        
        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = true
        }
        
        navigationController.setViewControllers([MainViewController()], animated: false)
        
        let mainVC = navigationController
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.hero.isEnabled = true
        mainVC.hero.modalAnimationType = .zoom
        
        present(mainVC, animated: true, completion: nil)
    }
}
