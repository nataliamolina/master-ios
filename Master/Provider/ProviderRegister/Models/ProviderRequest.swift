//
//  ProviderRequest.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct ProviderRequest: Codable {
    let nickName: String
    let photoUrl: String
    let description: String
    let document: String
    let bankAccountNumber: String
    let bankAccountType: String
    let bankName: String
}
