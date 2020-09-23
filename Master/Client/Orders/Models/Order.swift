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
    case ratingPending
    case unknown
    
    var id: Int {
        switch self {
        case .pending:
            return 1
            
        case .accepted:
            return 2
            
        case .inProgress:
            return 3
            
        case .rejected:
            return 4
            
        case .finished:
            return 5
            
        case .pendingForPayment:
            return 6
            
        case .paymentDone:
            return 7
            
        case .ratingPending, .unknown:
            return -1
        }
    }
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
    let city: City?
    let serviceRequirements: String?
    let excess: Double?
    let descriptionExcess: String?
}

struct OrderState: Codable {
    let type: OrderStateType
    
    enum CodingKeys: String, CodingKey {
        case type = "name"
    }
}
