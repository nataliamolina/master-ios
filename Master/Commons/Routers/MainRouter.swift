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
    case home(router: RouterBase<HomeRouterTransitions>)
}

class MainRouter: RouterBase<MainRouterTransitions> {
    // MARK: - Properties
    private let navigationController: UINavigationController
    
    // MARK: - Life Cycle
    override init(rootViewController: UIViewController) {
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
            handleEmailLoginTransition()
            
        case .home(let router):
            handleHomeTransition(router: router)
            
        case .register:
            handleRegisterTransition()
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
        let viewController = MainViewController()
        viewController.router = self
        
        navigationController.setViewControllers([viewController], animated: false)
        navigationController.interactivePopGestureRecognizer?.delegate = viewController
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
        
        rootViewController.present(navigationController, animated: true, completion: nil)
    }
    
    private func handleEmailLoginTransition() {
        let viewController = EmailLoginViewController()
        viewController.router = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleHomeTransition(router: RouterBase<HomeRouterTransitions>) {
        router.transition(to: .home)
    }
    
    private func handleRegisterTransition() {
        let viewController = RegisterViewController()
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
