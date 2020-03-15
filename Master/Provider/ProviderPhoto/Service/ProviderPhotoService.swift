//
//  ProviderPhotoService.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class ProviderPhotoService: ProviderPhotoServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    
    func updatePhoto(request: ProviderPhotoRequest, onComplete: @escaping (_ result: String?, _ error: CMError?) -> Void) {
        connectionDependency.put(url: Endpoint.updateProviderPhoto, request: request) { (response: String?, error: CMError?) in
            onComplete(response, error)
        }
    }
}
