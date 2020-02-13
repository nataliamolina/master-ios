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
    private let navigationController: UINavigationController
    
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
            navigationController.navigationBar.prefersLargeTitles = true
        }
        
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.hero.isEnabled = true
        navigationController.hero.modalAnimationType = .zoom
    }
    
    private func handleHomeTransition() {
        navigationController.setViewControllers([HomeViewController()], animated: false)
        
        rootViewController.present(navigationController, animated: true, completion: nil)
    }
    
    private func handleCategoryDetailTransition() {
    }
}
