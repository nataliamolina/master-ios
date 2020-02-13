//
//  ConnectionManager.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import Simple_Networking

class ConnectionManager: ConnectionManagerProtocol {
    // MARK: - Life Cycle
    init() {
        SimpleNetworking.debugMode = .all
    }
    
    // MARK: - Public Methods
    func setCustomHeaders(_ headers: [String: String]) {
        headers.forEach {
            SimpleNetworking.defaultHeaders[$0.key] = $0.value
        }
    }
    
    func setAuthenticationToken(_ token: String) {
        SimpleNetworking.setAuthenticationHeader(prefix: "Bearer ", token: token)
    }
    
    func get<T: Codable>(url: String, onComplete: ResultBlock<T>?) {
        SN.get(endpoint: url) { [weak self] (response: SNResultWithEntity<ServerResponse<T>, ServerResponse<EmptyCodable>>) in
            switch response {
            case .error(let error):
                onComplete?(nil, error)
                
            case .errorResult(let entity):
                onComplete?(nil, self?.getErrorWith(text: entity.userErrorMessage))
                
            case .success(let response):
                onComplete?(response.data, nil)
            }
        }
    }
    
    func post<T: Codable>(url: String,
                          request: Codable,
                          onComplete: ResultBlock<T>?) {
        
        SN.post(endpoint: url,
                model: request) { [weak self] (response: SNResultWithEntity<T, ServerResponse<EmptyCodable>>) in
                    
            switch response {
            case .error(let error):
                onComplete?(nil, error)
                
            case .errorResult(let entity):
                onComplete?(nil, self?.getErrorWith(text: entity.userErrorMessage))
                
            case .success(let response):
                onComplete?(response, nil)
            }
        }
    }
    
    // MARK: - Private Methods
    private func getErrorWith(text: String?) -> Error {
        return NSError(domain: "", code: 0, userInfo: ["error": text ?? ""])
    }
}

