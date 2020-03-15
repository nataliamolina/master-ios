//
//  ProviderPhotoServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ProviderPhotoServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func updatePhoto(request: ProviderPhotoRequest, onComplete: @escaping (_ result: String?, _ error: CMError?) -> Void)
}
