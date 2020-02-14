//
//  EmailLoginEndpoints.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

extension Endpoint {
    static var emailLogin: String {
        return base + "login"
    }
    
    static var getUserSession: String {
        return base + "user"
    }
    
    static var gmailLogin: String {
        return base + "login/gmail"
    }
}
