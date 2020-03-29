//
//  MenuRouter.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

enum MenuRouterTransitions {
    case menu
    case ordersList
    case legal
    case logout
    case privacy
    case help
}

class MenuRouter: RouterBase<MenuRouterTransitions> {
    // MARK: - Properties
    private let navigationController: MNavigationController
    private var onAuthenticated: CompletionBlock?
    
    // MARK: - Life Cycle
    init(navigationController: MNavigationController) {
        self.navigationController = navigationController
        
        super.init()
    }
    
    // MARK: - Public Methods
    override func transition(to transition: MenuRouterTransitions) {
        switch transition {
        case .menu:
            handleMenuTransition()
            
        case .legal:
            handleLegalTransition()
            
        case .ordersList:
            handleAuthOption { [weak self] in
                self?.handleOrdersTransition()
            }
            
        case .logout:
            handleLogoutTransition()
            
        case .privacy:
            handleLegalTransition()
            
        case .help:
            handleHelpTransition()
        }
    }
    
    // MARK: - Private Methods
    private func handleAuthOption(onAuthenticated: @escaping CompletionBlock) {
        if Session.shared.isLoggedIn {
            onAuthenticated()
            
            return
        }
        
        self.onAuthenticated = onAuthenticated
        
        let loginRouter = MainRouter(navigationController: navigationController, delegate: self)
        loginRouter.transition(to: .main)
    }
    
    private func handleMenuTransition() {
        let menuVC = MenuViewController(viewModel: MenuViewModel(), router: self)
        menuVC.modalPresentationStyle = .overCurrentContext
        
        navigationController.topViewController?.present(menuVC, animated: false, completion: nil)
    }
    
    private func handleLegalTransition() {
        let viewController = LegalViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleOrdersTransition() {
        let ordersRouter = OrdersRouter(navigationController: navigationController)
        ordersRouter.transition(to: .orders)
    }
    
    private func handleLogoutTransition() {
        let mainRouter = HomeRouter(navigationController: MNavigationController())
        mainRouter.transition(to: .home)
    }
    
    private func handleHelpTransition() {
        guard let whatsappURL = URL(string: Session.shared.helpUrl), UIApplication.shared.canOpenURL(whatsappURL) else {
            return
        }
        
        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
    }
}

// MARK: - MainRouterDelegate
extension MenuRouter: MainRouterDelegate {
    func authDidEnd(withSuccess: Bool) {
        guard withSuccess else {
            return
        }
        
        onAuthenticated?()
    }
}
