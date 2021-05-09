//
//  PushNotification.swift
//  Master
//
//  Created by Carlos Mejía on 9/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

enum PushNotificationType: String, Codable {
    case providerProfile = "PROVIDER_PROFILE"
    case providerOrderUpdated = "PROVIDER_ORDERS_UPDATED"
    case userOrderUpdated = "USER_ORDER_UPDATED"
    case chatProvider = "CHAT_PROVIDER"
    case chatUser = "CHAT_USER"
}

struct PushNotification: Codable {
    let title: String
    let message: String
    let actionType: PushNotificationType
    let actionId: String
    
    private enum CodingKeys: String, CodingKey {
        case title
        case message = "body"
        case actionType
        case actionId
    }
}
