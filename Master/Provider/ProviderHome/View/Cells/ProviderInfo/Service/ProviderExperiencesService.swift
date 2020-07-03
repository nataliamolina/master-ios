//
//  ProviderExperiencesService.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/2/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct ProviderExperiencesService: Codable {
    let id: Int
    let profession: String
    let university: String
    let dateSince: String
    let dateTo: String
    let city: String
    
    var providerInfoType: ProviderInfoType {
        return .studies
    }
}
