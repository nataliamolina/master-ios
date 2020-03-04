//
//  PaymentServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 3/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol PaymentServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func performPayment(request: PaymentRequest,
                        onComplete: @escaping (_ result: PaymentResponse?, _ error: CMError?) -> Void)
    
    func deleteAllCards(onComplete: @escaping (_ result: Bool, _ error: CMError?) -> Void)
}
