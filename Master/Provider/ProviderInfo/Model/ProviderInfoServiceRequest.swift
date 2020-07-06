//
//  ProviderInfoServiceModelRequest.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/5/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct ProviderInfoServiceModelRequest: Codable {
    var dataType: ProviderInfoType
    var position: String
    var location: String
    var startDate: String
    var endDate: String
    var isCurrent: Bool
    var country: String
    var city: String
}
