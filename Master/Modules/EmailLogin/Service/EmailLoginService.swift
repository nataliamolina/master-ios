//
//  EmailLoginService.swift
//  Master
//
//  Created by Carlos Mejía on 11/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

typealias ServiceResponseBlock<ResultModel: Codable> = (_ error: ErrorCustom?, _ result: ResultModel?) -> Void

protocol ServiceProtocol {
    func post<ResultModel: Codable>(to endpoint: Endpoint,
                                    model: Codable?,
                                    result: ServiceResponseBlock<ResultModel>)
    
    func get<ResultModel: Codable>(to endpoint: Endpoint,
                                   model: Codable?,
                                   result: ServiceResponseBlock<ResultModel>)
}

struct ErrorCustom: Codable {}
struct LoginResponse: Codable {}

class EmailLoginService {

}
