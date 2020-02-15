//
//  ServiceCategory.swift
//  Master
//
//  Created by Carlos Mejía on 14/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct ServiceCategory: Codable {
    let name: String
    let description: String
    let legalConditions: String
    let imageUrl: String
    let id: Int
}
