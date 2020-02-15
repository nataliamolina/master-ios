//
//  MenuViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import GoogleSignIn

struct MenuViewModel {
    func logout() {
        GIDSignIn.sharedInstance()?.signOut()
        Session.shared.token = nil
        Session.shared.profile = .empty
    }
}
