//
//  ProviderRegisterViewModelProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ProviderRegisterServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func createProvider(request: ProviderRequest, onComplete: @escaping (_ result: Provider?, _ error: CMError?) -> Void)
}
