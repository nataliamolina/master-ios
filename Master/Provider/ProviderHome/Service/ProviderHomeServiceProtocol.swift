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
    
    func fetchProviderServices(onComplete: @escaping (_ result: [ProviderService], _ error: CMError?) -> Void)
    func fetchProviderOrders(onComplete: @escaping (_ result: [Order], _ error: CMError?) -> Void)
}
