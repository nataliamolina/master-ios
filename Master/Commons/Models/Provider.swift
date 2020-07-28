//
//  Provider.swift
//  Master
//
//  Created by Carlos Mejía on 14/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct Provider: Codable {
    let id: Int
    let user: User
    let nickname: String
    var photoUrl: String
    let description: String
    let bankAccountNumber: String
    let bankAccountType: String
    let bankName: String
    let city: City?
    
    var asProviderProfile: ProviderProfile {
        return ProviderProfile(id: id,
                               user: user.asUserProfile,
                               photoUrl: photoUrl,
                               description: description,
                               bankAccountNumber: bankAccountNumber,
                               bankAccountType: bankAccountType,
                               bankName: bankName, city: city)
    }
}
