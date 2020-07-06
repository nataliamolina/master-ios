//
//  ProviderInfoModel.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/5/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct ProviderInfoModel: Codable {
    var id: Int?
    var dataType: ProviderInfoType
    var position: String
    var location: String
    var startDate: String
    var endDate: String
    var isCurrent: Bool
    var country: String
    var city: String
    
    init(id: Int?,
         dataType: ProviderInfoType,
         position: String,
         location: String,
         startDate: String,
         endDate: String,
         isCurrent: Bool,
         country: String,
         city: String) {
        
        self.id = id
        self.dataType = dataType
        self.position = position
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.isCurrent = isCurrent
        self.country = country
        self.city = city
    }
    
    init() {
        
        self.id = nil
        self.dataType = .none
        self.position = ""
        self.location = ""
        self.startDate = ""
        self.endDate = ""
        self.isCurrent = false
        self.country = ""
        self.city = ""
    }
}
