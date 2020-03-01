//
//  CheckoutRouter.swift
//  Master
//
//  Created by Carlos Mejía on 29/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

enum CheckoutRouterTransitions {
    case checkout(viewModel: CheckoutViewModel)
    case successOrder
    case ordersList
    case completeText(viewModel: CompleteTextViewModel, delegate: CompleteTextViewDelegate?)
}

class CheckoutRouter: RouterBase<CheckoutRouterTransitions> {
    // MARK: - Properties
    private var successOrderViewControllerRef: SuccessOrderViewController?
    let navigationController: UINavigationController
    
    // MARK: - Life Cycle
    override init(rootViewController: UIViewController) {
        self.navigationController = (rootViewController as? UINavigationController) ?? UINavigationController()
        
        super.init(rootViewController: rootViewController)
    }
    
    // MARK: - Public Methods
    override func transition(to transition: CheckoutRouterTransitions) {
        switch transition {
        case .checkout(let viewModel):
            handleCheckoutTransition(viewModel: viewModel)
            
        case .completeText(let viewModel, let delegate):
            handleCompelteTextTransition(viewModel: viewModel, delegate: delegate)
            
        case .successOrder:
            handleSuccessOrderTransition()
            
        case .ordersList:
            handleOrdersTransition()
        }
    }
    
    // MARK: - Private Methods
    private func handleCheckoutTransition(viewModel: CheckoutViewModel) {
        let viewController = CheckoutViewController(router: self, viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleCompelteTextTransition(viewModel: CompleteTextViewModel, delegate: CompleteTextViewDelegate?) {
        let viewController = CompleteTextViewController(viewModel: viewModel, delegate: delegate)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleSuccessOrderTransition() {
        let viewController = SuccessOrderViewController(router: self)
        viewController.modalPresentationStyle = .fullScreen
        viewController.hero.isEnabled = true
        viewController.hero.modalAnimationType = .zoom
        successOrderViewControllerRef = viewController
        
        navigationController.present(viewController, animated: true, completion: nil)
    }
    
    private func handleOrdersTransition() {
        successOrderViewControllerRef?.hero.modalAnimationType = .zoomOut
        
        successOrderViewControllerRef?.dismiss(animated: true, completion: { [weak self] in
            HomeViewModel.needsToOpenOrders = true
            
            self?.navigationController.popToRootViewController(animated: true)
            self?.successOrderViewControllerRef = nil
        })
    }
}
