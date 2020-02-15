//
//  OrderServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 14/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol OrderServiceProtocol: Codable {
    var id: Int { get }
    var name: String { get }
    var description: String { get }
    var price: Double { get }
    var serviceCategory: ServiceCategory? { get }
    var photoUrl: String? { get }
}
