//
//  MainRouter.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

enum MainRouterTransitions {
    case main
    case emailLogin
    case register
    case home
}

class MainRouter: RouterBase<MainRouterTransitions> {
    // MARK: - Properties
    private let navigationController: UINavigationController
    
    // MARK: - Life Cycle
    override init(rootViewController: BaseViewController) {
        self.navigationController = UINavigationController()
        
        super.init(rootViewController: rootViewController)
   
        setupNavigationController()
    }
    
    // MARK: - Public Methods
    override func transition(to transition: MainRouterTransitions) {
        switch transition {
        case .main:
            handleMainTransition()
            
        case .emailLogin:
            return
            
        case .home:
            return
            
        case .register:
            return
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
    
    private func handleMainTransition() {
        navigationController.setViewControllers([MainViewController()], animated: false)
        
        rootViewController.present(navigationController, animated: true, completion: nil)
    }
}
