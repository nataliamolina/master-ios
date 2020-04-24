//
//  CitySelectorServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 24/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol CitySelectorServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func fetchCities(onComplete: @escaping (_ result: [City], _ error: CMError?) -> Void)
}
