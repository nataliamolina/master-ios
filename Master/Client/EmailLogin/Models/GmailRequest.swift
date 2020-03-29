//
//  GmailRequest.swift
//  Master
//
//  Created by Carlos Mejía on 13/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct GmailRequest: Codable {
    let platformId: Int = Utils.platformId
    let photoUrl: String
    let id: String
    let gmailToken: String
    let email: String
    let firstName: String
    let lastName: String
}
