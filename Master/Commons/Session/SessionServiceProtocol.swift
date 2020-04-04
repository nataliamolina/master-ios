//
//  SessionServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 4/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol SessionServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func logout(onComplete: (() -> Void)?)
    func updatePushToken(_ token: String, onComplete: @escaping (_ result: String?, _ error: CMError?) -> Void)
}
