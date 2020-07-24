//
//  ProviderServiceModel.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/21/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct ProviderServiceModel: Codable {
    var id: Int?
    var photoUrl: String?
    var name: String
    var price: Double?
    var description: String
    var serviceCategory: ServiceCategory?
    
    static var empty: ProviderServiceModel {
        return ProviderServiceModel(id: nil,
                                    photoUrl: nil,
                                    name: "",
                                    price: nil,
                                    description: "",
                                    serviceCategory: nil)
    }
}
