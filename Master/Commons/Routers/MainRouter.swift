//
//  MainRouter.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

enum MainRouterTransitions {
    case main(onComplete: CompletionBlock?)
    case emailLogin
    case register
    case legal
    case backToPresenter
    case home
    case close
}

class MainRouter: RouterBase<MainRouterTransitions> {
    // MARK: - Properties
    private let navigationController: MNavigationController
    private var onComplete: CompletionBlock?
    
    // MARK: - Life Cycle
    init(navigationController: MNavigationController) {
        self.navigationController = navigationController
        
        super.init()
    }
    
    // MARK: - Public Methods
    override func transition(to transition: MainRouterTransitions) {
        switch transition {
        case .main(let onComplete):
            handleMainTransition(onComplete: onComplete)
            
        case .emailLogin:
            handleEmailLoginTransition()
            
        case .register:
            handleRegisterTransition()
            
        case .legal:
            handleLegalTransition()
            
        case .backToPresenter:
            navigationController.dismiss(animated: true) { [weak self] in
                self?.onComplete?()
            }
            
        case .home:
            handleHomeTransition()
            
        case .close:
            navigationController.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Private Methods
    
    private func handleMainTransition(onComplete: CompletionBlock?) {
        self.onComplete = onComplete
        
        let viewController = MainViewController()
        viewController.router = self
        
        navigationController.setViewControllers([viewController], animated: true)
        navigationController.interactivePopGestureRecognizer?.delegate = viewController
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func handleEmailLoginTransition() {
        let viewController = EmailLoginViewController()
        viewController.router = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleHomeTransition() {
        let homeRouter = HomeRouter(navigationController: navigationController)
        
        homeRouter.transition(to: .home)
    }
    
    private func handleRegisterTransition() {
        let viewController = RegisterViewController()
        viewController.router = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleLegalTransition() {
        let viewController = LegalViewController()
        viewController.customTitle = "legal.title".localized
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
