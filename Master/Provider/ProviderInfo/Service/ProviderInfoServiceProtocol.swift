//
//  ProviderInfoServiceModelProtocol.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/5/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ProviderInfoServiceModelProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func postProviderInfo(request: ProviderInfoServiceModelRequest,
                          onComplete: @escaping (_ result: [ProviderInfoServiceModel]?, _ error: CMError?) -> Void)
    
    func putProviderInfo(request: ProviderInfoServiceModel,
                         onComplete: @escaping (_ result: [ProviderInfoServiceModel]?, _ error: CMError?) -> Void)
}
