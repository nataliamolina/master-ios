//
//  ProviderMainServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ProviderMainServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func getProviderProfile(onComplete: @escaping (_ result: Provider?, _ error: CMError?) -> Void)
    func getProviderPhoto(onComplete: @escaping (_ result: String?, _ error: CMError?) -> Void)
}
