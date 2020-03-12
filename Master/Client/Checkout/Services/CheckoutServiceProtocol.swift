//
//  CheckoutServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 29/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol CheckoutServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func performCheckout(request: OrderRequest,
                         onComplete: @escaping (_ result: Order?, _ error: CMError?) -> Void)
}
