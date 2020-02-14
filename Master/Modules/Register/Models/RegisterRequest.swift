//
//  RegisterRequest.swift
//  Master
//
//  Created by Carlos Mejía on 13/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct RegisterRequest: Codable {
    let imageUrl: String
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let document: String
    let userProviderId: Int = 1
    let userDocumentId: Int = 1
    let userPlatformId: Int = 1
}
