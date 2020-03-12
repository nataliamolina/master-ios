//
//  RateViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 9/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum RateViewModelStatus {
    case undefined
    case error(error: String?)
    case rateSucceded
}

private enum Sections: Int {
    case header
    case buttons
    case list
}

class RateViewModel {
    // MARK: - Properties
    private let orderId: Int
    private let service: RateServiceProtocol
    
    let status = Var<RateViewModelStatus>(.undefined)
    let isLoading = Var(false)
    
    // MARK: - Life Cycle
    init(orderId: Int,
         service: RateServiceProtocol = RateService(connectionDependency: ConnectionManager())) {
        
        self.orderId = orderId
        self.service = service
    }
    
    // MARK: - Public Methods
    func postRate(comment: String, rate: Double) {
        loadingState(true)
        
        let request = CommentRequest(text: comment, score: rate, orderId: orderId)
        
        service.postComment(request: request) { [weak self] (_, error: CMError?) in
            self?.loadingState(false)
            
            if let error = error {
                self?.status.value = .error(error: error.error)
                
                return
            }
            
            self?.status.value = .rateSucceded
        }
    }
    
    // MARK: - Private Methods
    
    private func loadingState(_ state: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading.value = state
        }
    }
}
