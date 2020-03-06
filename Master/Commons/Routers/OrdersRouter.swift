//
//  OrdersRouter.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

enum OrdersRouterTransitions {
    case orders
    case orderDetail(viewModel: OrderDetailViewModel)
    case payment(viewModel: PaymentViewModel)
    case paymentDone
}

class OrdersRouter: RouterBase<OrdersRouterTransitions> {
    // MARK: - Properties
    let navigationController: UINavigationController
    
    // MARK: - Life Cycle
    override init(rootViewController: UIViewController) {
        self.navigationController = (rootViewController as? UINavigationController) ?? UINavigationController()
        
        super.init(rootViewController: rootViewController)
    }
    
    // MARK: - Public Methods
    override func transition(to transition: OrdersRouterTransitions) {
        switch transition {
        case .orders:
            handleOrdersTransition()
            
        case .orderDetail(let viewModel):
            handleOrderDetailTransition(viewModel: viewModel)
            
        case .payment(let viewModel):
            handlePaymentTransition(viewModel: viewModel)
            
        case .paymentDone:
            handlePaymentDoneTransition()
        }
    }
    
    // MARK: - Private Methods
    private func handleOrdersTransition() {
        let viewController = OrdersViewController(router: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handleOrderDetailTransition(viewModel: OrderDetailViewModel) {
        let viewController = OrderDetailViewController(viewModel: viewModel, router: self)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handlePaymentTransition(viewModel: PaymentViewModel) {
        let viewController = PaymentViewController(viewModel: viewModel, router: self)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func handlePaymentDoneTransition() {
        let checkoutRouter = CheckoutRouter(rootViewController: navigationController)
        
        navigationController.popToRootViewController {
            checkoutRouter.transition(to: .successOrder)
        }

    }
}
