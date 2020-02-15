//
//  ProviderService.swift
//  Master
//
//  Created by Carlos Mejía on 14/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct ProviderService: OrderServiceProtocol {
    let id: Int
    let photoUrl: String?
    let name: String
    let price: Double
    let description: String
    let order: Order?
    let serviceCategory: ServiceCategory?
    
    enum CodingKeys: String, CodingKey {
        case id
        case photoUrl
        case name = "nameSaved"
        case price = "priceSaved"
        case description = "descriptionSaved"
        case order
        case serviceCategory
    }
}
