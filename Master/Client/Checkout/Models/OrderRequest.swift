//
//  OrderRequest.swift
//  Master
//
//  Created by Carlos Mejía on 29/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct OrderRequest: Codable {
    let providerId: Int
    let orderAddress: String
    let userPlatformId: Int = 1
    let notes: String
    let serviceCategoryId: Int
    let servicesIds: [Int]
    let orderDate: String
    let time: String
}
