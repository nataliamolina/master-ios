//
//  ProviderWithScore.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct ProviderWithScore: Codable {
    let id: Int
    let userId: Int
    let names: String
    let nickname: String
    var score: Double
    var totalOrders: Int
    var photoUrl: String
    let description: String
}
