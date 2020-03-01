//
//  ServiceDetailServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ServiceDetailServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func fetchServiceDetailById(_ id: Int,
                                onComplete: @escaping (_ result: [ProviderWithScore]?, _ error: CMError?) -> Void)
}
