//
//  LoginRequest.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}
