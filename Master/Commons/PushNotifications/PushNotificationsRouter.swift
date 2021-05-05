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
    var providerRouter: RouterBase<ProviderRouterTransitions>?

    init(notification: PushNotification) {
        self.notification = notification
    }
    
    func navigateToPushNotification() {
        switch notification.type {
        case .userOrderUpdated:
            ordersRouter?.transition(to: .orderDetail(viewModel: getOrderDetailViewModel()))
            
        case .providerOrderUpdated:
            providerRouter?.transition(to: .orderDetailFromPush(viewModel: getProviderOrderDetailViewModel()))
            
        case .providerProfile:
            providerRouter?.transition(to: .showProfile)
            
        case .chatProvider:
            providerRouter?.transition(to: .orderDetailFromPush(viewModel: getProviderOrderDetailViewModel()))
            
        case .chatUser:
            ordersRouter?.transition(to: .orderDetail(viewModel: getOrderDetailViewModel()))
        }
        
        PushNotifications.shared.notificationResolved()
    }
    
    private func getProviderOrderDetailViewModel() -> ProviderOrderDetailViewModel {
        return ProviderOrderDetailViewModel(orderId: Int(notification.actionId) ?? 0)
    }
    
    private func getOrderDetailViewModel() -> OrderDetailViewModel {
        return OrderDetailViewModel(orderId: Int(notification.actionId) ?? 0)
    }
}
