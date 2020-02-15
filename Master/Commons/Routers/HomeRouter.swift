//
//  HomeRouter.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

enum HomeRouterTransitions {
    case categoryDetail(id: Int, serviceImageUrl: String)
    case home
    case logout
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
        case .categoryDetail(let id, let serviceImageUrl):
            handleCategoryDetailTransition(serviceId: id, serviceImageUrl: serviceImageUrl)
            
        case .home:
            handleHomeTransition()
            
        case .logout:
            handleLogoutTransition()
            
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
        let viewController = HomeViewController(router: self)
        navigationController.setViewControllers([viewController], animated: false)

        rootViewController.present(navigationController, animated: true, completion: nil)
    }
    
    private func handleCategoryDetailTransition(serviceId: Int, serviceImageUrl: String) {
        let viewModel = ServiceDetailViewModel(serviceId: serviceId, serviceImageUrl: serviceImageUrl)
        let viewController = ServiceDetailViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleLogoutTransition() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
