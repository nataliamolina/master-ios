//
//  ProviderProfile.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct ProviderProfile {
    let id: Int
    let user: UserProfile
    var photoUrl: String?
    let description: String
    let bankAccountNumber: String
    let bankAccountType: String
    let bankName: String
    let city: City?
}
