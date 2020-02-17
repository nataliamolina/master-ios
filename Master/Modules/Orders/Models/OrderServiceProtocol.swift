//
//  OrderServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 14/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol OrderServiceProtocol {
    func getId() -> Int
    func getName() -> String
    func getDescription() -> String
    func getPrice() -> Double
    func getServiceCategory() -> ServiceCategory?
    func getPhotoUrl() -> String?
}
