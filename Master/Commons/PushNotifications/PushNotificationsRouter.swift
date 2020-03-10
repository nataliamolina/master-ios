//
//  PushNotificationsRouter.swift
//  Master
//
//  Created by Carlos Mejía on 9/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class PushNotificationsRouter {
    private let notification: PushNotification
    var ordersRouter: RouterBase<OrdersRouterTransitions>?
    
    init(notification: PushNotification) {
        self.notification = notification
    }
    
    func navigateToPushNotification() {
        switch notification.type {
        case .userOrderUpdated:
            ordersRouter?.transition(to: .orderDetail(viewModel: getOrderDetailViewModel()))
        default:
            return
        }
    }
    
    private func getOrderDetailViewModel() -> OrderDetailViewModel {
        return OrderDetailViewModel(orderId: Int(notification.actionId) ?? 0)
    }
}
