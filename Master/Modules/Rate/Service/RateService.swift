//
//  RateService.swift
//  Master
//
//  Created by Carlos Mejía on 9/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class RateService: RateServiceProtocol {
    // MARK: - Properties
    let connectionDependency: ConnectionManagerProtocol
    
    // MARK: - Life Cycle
    init(connectionDependency: ConnectionManagerProtocol) {
        self.connectionDependency = connectionDependency
    }
    
    // MARK: - Public Methods
    
    func postComment(request: CommentRequest,
                     onComplete: @escaping (_ result: Comment?, _ error: CMError?) -> Void) {
        
        connectionDependency
            .post(url: Endpoint.addComment, request: request) { (response: Comment?, error: CMError?) in
                
                onComplete(response, error)
        }
    }
}
