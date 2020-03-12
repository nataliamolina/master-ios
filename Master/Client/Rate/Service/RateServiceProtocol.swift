//
//  RateServiceProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 9/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol RateServiceProtocol {
    var connectionDependency: ConnectionManagerProtocol { get }
    
    func postComment(request: CommentRequest,
                     onComplete: @escaping (_ result: Comment?, _ error: CMError?) -> Void)
}
