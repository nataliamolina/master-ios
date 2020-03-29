//
//  AppleSignInRequest.swift
//  Master
//
//  Created by Carlos Mejía on 29/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct AppleSignInRequest: Codable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let platformId: Int = Utils.platformId
}
