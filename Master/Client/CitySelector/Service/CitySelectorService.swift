//
//  CitySelectorService.swift
//  Master
//
//  Created by Carlos Mejía on 24/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class CitySelectorService: CitySelectorServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    func fetchCities(onComplete: @escaping (_ result: [City], _ error: CMError?) -> Void) {
        connectionDependency
            .get(url: Endpoint.cities) { (response: [City]?, error: CMError?) in
                
                onComplete(response ?? [], error)
        }
    }
}
