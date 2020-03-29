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
    case completeText(viewModel: CompleteTextViewModel, delegate: CompleteTextViewDelegate?)
    case login(onComplete: CompletionBlock)
}

class CheckoutRouter: RouterBase<CheckoutRouterTransitions> {
    // MARK: - Properties
    private var successOrderViewControllerRef: SuccessOrderViewController?
    private let navigationController: MNavigationController
    private var onAuthenticated: CompletionBlock?
    private let loginFlowRouter: MainRouter

    // MARK: - Life Cycle
    init(navigationController: MNavigationController) {
        self.navigationController = navigationController
        self.loginFlowRouter = MainRouter(navigationController: navigationController, delegate: nil)

        super.init()
        
        self.loginFlowRouter.delegate = self
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
            
        case .login(let onComplete):
            handleLoginTransition(onComplete: onComplete)
        }
    }
    
    // MARK: - Private Methods
    private func handleLoginTransition(onComplete: @escaping CompletionBlock) {
        self.onAuthenticated = onComplete
        
        loginFlowRouter.transition(to: .main)
    }
    
    private func handleCheckoutTransition(viewModel: CheckoutViewModel) {
        let viewController = CheckoutViewController(router: self, viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleCompelteTextTransition(viewModel: CompleteTextViewModel, delegate: CompleteTextViewDelegate?) {
        let viewController = CompleteTextViewController(viewModel: viewModel, delegate: delegate)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleSuccessOrderTransition() {
        let viewController = SuccessOrderViewController(router: HomeRouter(navigationController: MNavigationController()))
        viewController.modalPresentationStyle = .fullScreen
        viewController.hero.isEnabled = true
        viewController.hero.modalAnimationType = .zoom
        successOrderViewControllerRef = viewController
        
        navigationController.present(viewController, animated: true, completion: nil)
    }
    
    private func handleOrdersTransition() {
        successOrderViewControllerRef?.hero.modalAnimationType = .zoomOut
        
        successOrderViewControllerRef?.dismiss(animated: true, completion: { [weak self] in
            HomeViewModel.needsToReloadOrders = true
            
            self?.navigationController.popToRootViewController(animated: true)
            self?.successOrderViewControllerRef = nil
        })
    }
}

// MARK: - MainRouterDelegate
extension CheckoutRouter: MainRouterDelegate {
    func authDidEnd(withSuccess: Bool) {
        guard withSuccess else {
            return
        }
        
        onAuthenticated?()
    }
}
