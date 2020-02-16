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
}
