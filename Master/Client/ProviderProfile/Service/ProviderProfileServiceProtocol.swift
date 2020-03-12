//
//  ProviderProfileServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ProviderProfileServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func fetchProfile(userId: Int, onComplete: @escaping (_ result: Provider?, _ error: CMError?) -> Void)
    
    func fetchProviderServices(providerId: Int,
                               categoryId: Int,
                               onComplete: @escaping (_ result: [ProviderService]?, _ error: CMError?) -> Void)
    
    func fetchComments(providerId: Int, onComplete: @escaping (_ result: CommentsResponse?, _ error: CMError?) -> Void)
}
