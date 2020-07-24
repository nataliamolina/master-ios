//
//  ProviderEditRequest.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/23/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct ProviderEditRequest: Codable {
    let photoUrl: String
    let description: String
    let document: String
    let bankAccountNumber: String
    let bankAccountType: String
    let bankName: String
    let cityId: Int
}
