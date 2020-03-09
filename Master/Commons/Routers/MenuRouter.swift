//
//  MenuRouter.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import SideMenu

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
    private var sideMenuNavigationController: SideMenuNavigationController?
    let navigationController: UINavigationController
    
    // MARK: - Life Cycle
    override init(rootViewController: UIViewController) {
        self.navigationController = (rootViewController as? UINavigationController) ?? UINavigationController()
        
        super.init(rootViewController: rootViewController)
    }
    
    // MARK: - Public Methods
    override func transition(to transition: MenuRouterTransitions) {
        switch transition {
        case .menu:
            handleMenuTransition()
            
        case .legal:
            handleLegalTransition()
            
        case .ordersList:
            handleOrdersTransition()
            
        case .logout:
            handleLogoutTransition()
            
        case .privacy:
            handleLegalTransition()
            
        case .help:
            handleHelpTransition()
            
        }
    }
    
    deinit {
        sideMenuNavigationController = nil
    }
    
    // MARK: - Private Methods
    private func handleMenuTransition() {
        let menuVC = MenuViewController(router: self)
        
        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: menuVC)
        leftMenuNavigationController.setNavigationBarHidden(true, animated: false)
        leftMenuNavigationController.menuWidth = UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 4)
        leftMenuNavigationController.statusBarEndAlpha = 0
        
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        SideMenuManager.default.leftMenuNavigationController?.presentationStyle = .menuSlideIn
        SideMenuManager.default.leftMenuNavigationController?.presentationStyle.presentingEndAlpha = 0.5
        
        sideMenuNavigationController = leftMenuNavigationController
        navigationController.present(leftMenuNavigationController, animated: true, completion: nil)
    }
    
    private func handleLegalTransition() {
        let viewController = LegalViewController()
        
        sideMenuNavigationController?.dismiss(animated: true) { [weak self] in
            self?.navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    private func handleOrdersTransition() {
        let ordersRouter = OrdersRouter(rootViewController: navigationController)
        
        sideMenuNavigationController?.dismiss(animated: true) {
            ordersRouter.transition(to: .orders)
        }
    }
    
    private func handleLogoutTransition() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    private func handleHelpTransition() {
        guard let whatsappURL = URL(string: Session.shared.helpUrl), UIApplication.shared.canOpenURL(whatsappURL) else {
            return
        }
        
        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
    }
}
