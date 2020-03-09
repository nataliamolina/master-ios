//
//  MenuServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 9/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol MenuServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func logout(onComplete: (() -> Void)?)
}
