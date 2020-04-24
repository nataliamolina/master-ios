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
    case legal
    case backToPresenter
    case home
    case close
    case asRoot
    case citySelector(viewModel: CitySelectorViewModel)
}

protocol MainRouterDelegate: class {
    func authDidEnd(withSuccess: Bool)
}

class MainRouter: RouterBase<MainRouterTransitions> {
    // MARK: - Properties
    private let navigationController: MNavigationController
    private let mainNavigationController: MNavigationController
    weak var delegate: MainRouterDelegate?
    
    // MARK: - Life Cycle
    init(navigationController: MNavigationController, delegate: MainRouterDelegate?) {
        self.navigationController = navigationController
        self.mainNavigationController = MNavigationController()
        self.delegate = delegate
        
        super.init()
    }
    
    // MARK: - Public Methods
    override func transition(to transition: MainRouterTransitions) {
        switch transition {
        case .main:
            handleMainTransition()
            
        case .emailLogin:
            handleEmailLoginTransition()
            
        case .register:
            handleRegisterTransition()
            
        case .legal:
            handleLegalTransition()
            
        case .backToPresenter:
            mainNavigationController.popToRootViewController { [weak self] in
                self?.mainNavigationController.dismiss(animated: true) {
                    self?.delegate?.authDidEnd(withSuccess: Session.shared.token != nil)
                }
            }
            
        case .home:
            handleHomeTransition()
            
        case .close:
            navigationController.dismiss(animated: true, completion: nil)
            
        case .asRoot:
            handleAsRootTransition()
            
        case .citySelector(let viewModel):
            handleCitySelector(viewModel: viewModel)
        }
    }
    
    // MARK: - Private Methods
    private func handleAsRootTransition() {
        let newRouter = MainRouter(navigationController: mainNavigationController, delegate: nil)
        let viewController = MainViewController(router: newRouter, viewModel: MainViewModel())
        
        mainNavigationController.setViewControllers([viewController], animated: true)
        mainNavigationController.interactivePopGestureRecognizer?.delegate = viewController
        mainNavigationController.interactivePopGestureRecognizer?.isEnabled = true
        
        Master.setRootVC(navigationController: mainNavigationController)
    }
    
    private func handleCitySelector(viewModel: CitySelectorViewModel) {
        let viewController = CitySelectorViewController(viewModel: viewModel, router: self)
        viewController.modalPresentationStyle = .fullScreen
        
        Master.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    private func handleMainTransition() {
        let viewController = MainViewController(router: self, viewModel: MainViewModel())
        
        mainNavigationController.setViewControllers([viewController], animated: true)
        mainNavigationController.interactivePopGestureRecognizer?.delegate = viewController
        mainNavigationController.interactivePopGestureRecognizer?.isEnabled = true
        
        navigationController.present(mainNavigationController, animated: true, completion: nil)
    }
    
    private func handleEmailLoginTransition() {
        let viewController = EmailLoginViewController(router: self, viewModel: EmailLoginViewModel())
        
        mainNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleHomeTransition() {
        let homeRouter = HomeRouter(navigationController: navigationController)
        
        homeRouter.transition(to: .home)
    }
    
    private func handleRegisterTransition() {
        let viewController = RegisterViewController()
        viewController.router = self
        
        mainNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleLegalTransition() {
        let viewController = LegalViewController()
        viewController.customTitle = "legal.title".localized
        
        mainNavigationController.pushViewController(viewController, animated: true)
    }
}
