//
//  ProviderInfoServiceModel.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/5/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct ProviderInfoServiceModel: Codable {
    let id: Int
    let dataType: ProviderInfoType
    let position: String
    let location: String
    let startDate: String
    let endDate: String
    let isCurrent: Bool
    let country: String
    let city: String
}
