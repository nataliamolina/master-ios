//
//  Order.swift
//  Master
//
//  Created by Carlos Mejía on 14/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

enum OrderStateType: String, Codable {
    case pending = "pending"
    case accepted = "accepted"
    case inProgress = "in_progress"
    case rejected = "rejected"
    case finished = "finished"
    case pendingForPayment = "pending_for_payment"
    case paymentDone = "payment_done"
}

struct Order: Codable {
    let id: Int
    let user: User
    let provider: Provider
    let serviceCategory: ServiceCategory?
    let orderAddress: String
    let grossTotal: Double
    let createdAt: String
    let orderDate: String
    var orderState: OrderState
    let notes: String
    let time: String?
    let orderProviderServices: [OrderProviderService]?
}

struct OrderState: Codable {
    let type: OrderStateType
    
    enum CodingKeys: String, CodingKey {
        case type = "name"
    }
}
