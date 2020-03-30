//
//  HomeRouter.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

enum HomeRouterTransitions {
    case providerList(id: Int, serviceImageUrl: String)
    case providerDetail(viewModel: ProviderProfileViewModel)
    case checkout(viewModel: CheckoutViewModel)
    case completeText(viewModel: CompleteTextViewModel, delegate: CompleteTextViewDelegate?)
    case orders
    case reserveDone
    case home
    case productSelector(viewModel: ProductSelectorDataSource, delegate: ProductSelectorDelegate)
    case menu
    case providerHome
}

class HomeRouter: RouterBase<HomeRouterTransitions> {
    // MARK: - Properties
    private let navigationController: MNavigationController
    private let menuRouter: MenuRouter
    private var onAuthenticated: CompletionBlock?

    // MARK: - Life Cycle
    init(navigationController: MNavigationController) {
        self.navigationController = navigationController
        self.menuRouter = MenuRouter(navigationController: navigationController)
        
        super.init()
        
        setupNavigationController()
    }
    
    // MARK: - Public Methods
    override func transition(to transition: HomeRouterTransitions) {
        switch transition {
        case .providerList(let id, let serviceImageUrl):
            handleCategoryDetailTransition(serviceId: id, serviceImageUrl: serviceImageUrl)
            
        case .completeText(let viewModel, let delegate):
            handleCompelteTextTransition(viewModel: viewModel, delegate: delegate)
            
        case .reserveDone:
            return
            
        case .home:
            handleHomeTransition()
 
        case .providerDetail(let viewModel):
            handleProviderDetailTransition(viewModel: viewModel)
            
        case .checkout(let viewModel):
            handleCheckoutTransition(viewModel: viewModel)
            
        case .orders:
            handleOrdersTransition()
            
        case .productSelector(let viewModel, let delegate):
            handleProductSelectorTransition(viewModel: viewModel, delegate: delegate)
            
        case .menu:
            handleMenuTransition()
            
        case .providerHome:
            handleAuthOption { [weak self] in
                self?.handleProviderTransition()
            }
        }
    }
    
    // MARK: - Private Methods
    private func setupNavigationController() {
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.hero.isEnabled = true
        navigationController.hero.modalAnimationType = .zoom
    }
    
    private func handleAuthOption(onAuthenticated: @escaping CompletionBlock) {
        if Session.shared.isLoggedIn {
            onAuthenticated()
            
            return
        }
        
        self.onAuthenticated = onAuthenticated
        
        let loginRouter = MainRouter(navigationController: navigationController, delegate: self)
        loginRouter.transition(to: .main)
    }
    
    private func handleProductSelectorTransition(viewModel: ProductSelectorDataSource,
                                                 delegate: ProductSelectorDelegate) {
        
        let viewController = ProductSelectorViewController(viewModel: viewModel, delegate: delegate)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleMenuTransition() {
        menuRouter.transition(to: .menu)
    }
    
    private func handleHomeTransition() {
        let viewController = HomeViewController(router: self)
        navigationController.setViewControllers([viewController], animated: false)
        navigationController.hero.isEnabled = true
        navigationController.hero.modalAnimationType = .zoom
        
        Master.setRootVC(navigationController: navigationController)
    }
    
    private func handleCategoryDetailTransition(serviceId: Int, serviceImageUrl: String) {
        let viewModel = ProviderListViewModel(serviceId: serviceId, serviceImageUrl: serviceImageUrl)
        let viewController = ProviderListViewController(viewModel: viewModel, router: self)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleProviderDetailTransition(viewModel: ProviderProfileViewModel) {
        let viewController = ProviderProfileViewController(viewModel: viewModel, router: self)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleCheckoutTransition(viewModel: CheckoutViewModel) {
        let checkoutRouter = CheckoutRouter(navigationController: navigationController)
        checkoutRouter.transition(to: .checkout(viewModel: viewModel))
    }
    
    private func handleCompelteTextTransition(viewModel: CompleteTextViewModel, delegate: CompleteTextViewDelegate?) {
        let viewController = CompleteTextViewController(viewModel: viewModel, delegate: delegate)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleOrdersTransition() {
        let ordersRouter = OrdersRouter(navigationController: navigationController)
        ordersRouter.transition(to: .orders)
    }
    
    private func handleProviderTransition() {
        navigationController.popViewControllerWithHandler { [weak self] in
            guard let self = self else { return }
            
            let router = ProviderRouter(navigationController: self.navigationController)
            router.transition(to: .main)
        }
    }
}

// MARK: - MainRouterDelegate
extension HomeRouter: MainRouterDelegate {
    func authDidEnd(withSuccess: Bool) {
        guard withSuccess else {
            return
        }
        
        onAuthenticated?()
    }
}
