//
//  ProviderOrderDetailServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ProviderOrderDetailServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func fetchOrderDetailBy(id: Int,
                            onComplete: @escaping (_ result: Order?, _ error: CMError?) -> Void)
    
    func fetchOrderServices(id: Int,
                            onComplete: @escaping (_ result: [OrderProviderService], _ error: CMError?) -> Void)
    
    func validateOrderRating(id: Int,
                             onComplete: @escaping (_ result: Bool, _ error: CMError?) -> Void)
}
