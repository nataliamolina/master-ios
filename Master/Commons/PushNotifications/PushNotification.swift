//
//  PushNotification.swift
//  Master
//
//  Created by Carlos Mejía on 9/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

enum PushNotificationType: String, Codable {
    case providerOrderUpdated = "PROVIDER_ORDERS_UPDATED"
    case userOrderUpdated = "USER_ORDER_UPDATED"
}

struct PushNotification: Codable {
    let title: String
    let message: String
    let type: PushNotificationType
    let actionId: String
}
