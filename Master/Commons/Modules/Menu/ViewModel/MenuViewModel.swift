//
//  MenuViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import GoogleSignIn

class MenuViewModel {
    private let service: MenuServiceProtocol
    
    // MARK: - Life Cycle
    init(service: MenuServiceProtocol? = nil) {
        let defaultService = MenuService(connectionDependency: ConnectionManager())
        
        self.service = service ?? defaultService
    }
    
    func logout() {
        Session.shared.logout()
    }
}
