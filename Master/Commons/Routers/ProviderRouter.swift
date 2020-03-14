//
//  ProviderRouter.swift
//  Master
//
//  Created by Carlos Mejía on 12/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

enum ProviderRouterTransitions {
    case main
    case register
    case uploadPhoto
    case home
    case listSelector(viewModel: ListSelectorViewModel, delegate: ListSelectorViewControllerDelegate?)
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
        case .main:
            handleMainTransition()
            
        case .home:
            return
            
        case .register:
            handleRegisterTransition()
            
        case .uploadPhoto:
            handleUploadTransition()
            
        case .listSelector(let viewModel, let delegate):
            handleListSelectorTransition(viewModel: viewModel, delegate: delegate)
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
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.hero.isEnabled = true
        navigationController.hero.modalAnimationType = .zoom
    }
    
    private func handleMainTransition() {
        let viewController = ProviderMainViewController(router: self, viewModel: ProviderMainViewModel())
        navigationController.setViewControllers([viewController], animated: false)
        navigationController.interactivePopGestureRecognizer?.delegate = viewController
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
        
        rootViewController.present(navigationController, animated: true, completion: nil)
    }
    
    private func handleRegisterTransition() {
        let viewController = ProviderRegisterViewController(router: self, viewModel: ProviderRegisterViewModel())
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleUploadTransition() {
        let viewController = ProviderPhotoViewController()
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleListSelectorTransition(viewModel: ListSelectorViewModel, delegate: ListSelectorViewControllerDelegate?) {
        let viewController = ListSelectorViewController(viewModel: viewModel, delegate: delegate)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
