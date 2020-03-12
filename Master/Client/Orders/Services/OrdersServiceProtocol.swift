//
//  OrdersServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol OrdersServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func fetchOrders(onComplete: @escaping (_ result: [Order]?, _ error: CMError?) -> Void)
}
