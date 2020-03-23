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
    case rateOrder(viewModel: RateViewModel)
    case payment(viewModel: PaymentViewModel)
    case paymentDone
    case endFlow(onComplete: (() -> Void)?)
}

class OrdersRouter: RouterBase<OrdersRouterTransitions> {
    // MARK: - Properties
    private let navigationController: UINavigationController
    
    // MARK: - Life Cycle
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        super.init()
    }
    
    // MARK: - Public Methods
    override func transition(to transition: OrdersRouterTransitions) {
        switch transition {
        case .orders:
            handleOrdersTransition()
            
        case .rateOrder(let viewModel):
            handleRateOrderTransition(viewModel: viewModel)
            
        case .orderDetail(let viewModel):
            handleOrderDetailTransition(viewModel: viewModel)
            
        case .payment(let viewModel):
            handlePaymentTransition(viewModel: viewModel)
            
        case .paymentDone:
            handlePaymentDoneTransition()
            
        case .endFlow(let onComplete):
            routeToEndFlow(onComplete: onComplete)
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
        let checkoutRouter = CheckoutRouter(navigationController: navigationController)
        
        navigationController.popToRootViewController {
            checkoutRouter.transition(to: .successOrder)
        }
    }
    
    private func routeToEndFlow(onComplete: (() -> Void)?) {
        navigationController.popToRootViewController(completion: onComplete)
    }
    
    private func handleRateOrderTransition(viewModel: RateViewModel) {
        let viewController = RateViewController(router: self, viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
