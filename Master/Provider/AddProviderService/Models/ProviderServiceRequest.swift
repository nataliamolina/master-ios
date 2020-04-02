//
//  ProviderServiceRequest.swift
//  Master
//
//  Created by Carlos Mejía on 2/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct ProviderServiceRequest: Codable {
    let photoUrl: String
    let name: String
    let price: Double
    let description: String
    let serviceCategoryId: Int
}
