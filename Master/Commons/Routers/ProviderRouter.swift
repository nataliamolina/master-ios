//
//  ProviderRouter.swift
//  Master
//
//  Created by Carlos Mejía on 12/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

enum ProviderRouterTransitions {
    case home
}

class ProviderRouter: RouterBase<ProviderRouterTransitions> {
    // MARK: - Properties
    let navigationController: UINavigationController
    
    // MARK: - Life Cycle
    override init(rootViewController: UIViewController) {
        self.navigationController = UINavigationController()
        
        super.init(rootViewController: rootViewController)
        
        setupNavigationController()
    }
    
    // MARK: - Public Methods
    override func transition(to transition: ProviderRouterTransitions) {
        switch transition {
        case .home:
            handleHomeTransition()
        }
    }
    
    // MARK: - Private Methods
    private func setupNavigationController() {
        navigationController.navigationBar.tintColor = UIColor.Master.green
        
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.barTintColor = UIColor(white: 1, alpha: 0)
        navigationController.view.backgroundColor = .clear
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.hero.isEnabled = true
        navigationController.hero.modalAnimationType = .zoom
    }
    
    private func handleHomeTransition() {
        let viewController = ProviderMainViewController()
        navigationController.setViewControllers([viewController], animated: false)
        
        rootViewController.present(navigationController, animated: true, completion: nil)
    }
}
