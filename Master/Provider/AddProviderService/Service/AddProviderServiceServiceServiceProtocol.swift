//
//  AddProviderServiceServiceServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 2/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol AddProviderServiceServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func getServiceCategories(onComplete: @escaping (_ result: [ServiceCategory], _ error: CMError?) -> Void)
    func postProviderService(request: ProviderServiceRequest,
                             onComplete: @escaping (_ result: ProviderService?, _ error: CMError?) -> Void)
}
