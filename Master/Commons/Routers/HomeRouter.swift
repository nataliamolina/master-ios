//
//  HomeRouter.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

enum HomeRouterTransitions {
    case categoryDetail
    case home
}

class HomeRouter: RouterBase<HomeRouterTransitions> {
    // MARK: - Properties
    let navigationController: UINavigationController
    
    // MARK: - Life Cycle
    override init(rootViewController: UIViewController) {
        self.navigationController = UINavigationController()
        
        super.init(rootViewController: rootViewController)
        
        setupNavigationController()
    }
    
    // MARK: - Public Methods
    override func transition(to transition: HomeRouterTransitions) {
        switch transition {
        case .categoryDetail:
            handleCategoryDetailTransition()
            
        case .home:
            handleHomeTransition()
        }
    }
    
    // MARK: - Private Methods
    private func setupNavigationController() {
        navigationController.navigationBar.tintColor = UIColor.Master.green
        
        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = false
        }
        
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.backgroundColor = .white
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.isTranslucent = true
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.hero.isEnabled = true
        navigationController.hero.modalAnimationType = .zoom
    }
    
    private func handleHomeTransition() {
        let viewController = HomeViewController()
        viewController.router = self
        
        navigationController.setViewControllers([viewController], animated: false)

        rootViewController.present(navigationController, animated: true, completion: nil)
    }
    
    private func handleCategoryDetailTransition() {
        navigationController.pushViewController(ServiceDetailViewController(), animated: true)
    }
}
