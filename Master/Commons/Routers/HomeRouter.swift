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
    
    // MARK: - Life Cycle
    init(navigationController: MNavigationController) {
        self.navigationController = navigationController
        
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
            handleProviderTransition()
            
        }
    }
    
    // MARK: - Private Methods
    private func setupNavigationController() {
        navigationController.navigationBar.tintColor = UIColor.Master.green
        
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.backgroundColor = .white
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.isTranslucent = true
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.hero.isEnabled = true
        navigationController.hero.modalAnimationType = .zoom
    }
    
    private func handleProductSelectorTransition(viewModel: ProductSelectorDataSource,
                                                 delegate: ProductSelectorDelegate) {
        
        let viewController = ProductSelectorViewController(viewModel: viewModel, delegate: delegate)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleMenuTransition() {
        let menuRouter = MenuRouter(navigationController: navigationController)
        menuRouter.transition(to: .menu)
    }
    
    private func handleHomeTransition() {
        let viewController = HomeViewController(router: self)
        navigationController.setViewControllers([viewController], animated: false)
        navigationController.hero.isEnabled = true
        navigationController.hero.modalAnimationType = .zoom
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }

        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3

        window.rootViewController = navigationController
        
        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
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
        guard let topVC = navigationController.topViewController else {
            return
        }
        
        let router = ProviderRouter(navigationController: navigationController)
        router.transition(to: .main)
    }
}
