//
//  HomeServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol HomeServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func fetchServices(onComplete: @escaping (_ result: [Service]?, _ error: CMError?) -> Void)
    
    func updatePushToken(_ token: String, onComplete: @escaping (_ result: String?, _ error: CMError?) -> Void)
}
