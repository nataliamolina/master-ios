//
//  UserProfile.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct UserProfile {
    let id: Int
    let imageUrl: String
    let email: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let document: String
    
    static var empty: UserProfile {
        return UserProfile(id: -1,
                           imageUrl: "",
                           email: "",
                           firstName: "",
                           lastName: "",
                           phoneNumber: "",
                           document: "")
    }
}
