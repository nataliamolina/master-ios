//
//  ProviderHomeServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ProviderHomeServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func fetchProfile(userId: Int, onComplete: @escaping (_ result: Provider?, _ error: CMError?) -> Void)
}
