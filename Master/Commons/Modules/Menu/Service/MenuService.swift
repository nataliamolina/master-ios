//
//  MenuService.swift
//  Master
//
//  Created by Carlos Mejía on 9/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class MenuService: MenuServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    
    func logout(onComplete: (() -> Void)?) {
        connectionDependency.putWithBoolResponse(url: Endpoint.logout) { (_, _) in
            onComplete?()
        }
    }
}
