//
//  OrderProviderService.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct OrderProviderService: Codable, OrderServiceProtocol {
    let id: Int
    let nameSaved: String
    let priceSaved: Double
    let descriptionSaved: String
    let providerService: ProviderService?
    
    func getId() -> Int {
        return id
    }
    
    func getName() -> String {
        return nameSaved
    }
    
    func getDescription() -> String {
        return descriptionSaved
    }
    
    func getPrice() -> Double {
        return priceSaved
    }
    
    func getServiceCategory() -> ServiceCategory? {
        return nil
    }
    
    func getPhotoUrl() -> String? {
        return providerService?.photoUrl
    }
}
