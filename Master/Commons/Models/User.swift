//
//  User.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int
    let imageUrl: String
    let email: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let document: String
    let provider: UserProvider?
    let DocumentType: UserDocument?
}

struct UserProvider: Codable {
    let name: String
}

struct UserDocument: Codable {
    let name: String
}
