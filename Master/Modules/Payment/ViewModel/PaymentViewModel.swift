//
//  PaymentViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 3/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding
import Paymentez

enum PaymentViewModelStatus {
    case paymentReady
    case undefined
    case error(error: String?)
}

class PaymentViewModel {
    // MARK: - Properties
    let status = Var<PaymentViewModelStatus>(.undefined)
    let isLoading = Var(false)
    
    private typealias SDK = PaymentezSDKClient
    private let userId: String
    private let userEmail: String
    private let orderId: Int
    private let service: PaymentServiceProtocol
    
    // MARK: - Life Cycle
    init(service: PaymentServiceProtocol? = nil, orderId: Int, userId: Int, userEmail: String) {
        let defaultService = PaymentService(connectionDependency: ConnectionManager())
        
        self.userId = userId.asString
        self.userEmail = userEmail
        self.orderId = orderId
        self.service = service ?? defaultService
    }
    
    // MARK: - Public Methods
    
    func addCardAndPay(_ card: PaymentezCard) {
        isLoading.value = true
        
        SDK.add(card, uid: userId, email: userEmail) { [weak self] (error: PaymentezSDKError?, card: PaymentezCard?) in
            self?.isLoading.value = false

            guard let card = card, let cardToken = card.token, error == nil else {
                self?.status.value = .error(error: nil)
                
                return
            }
            
            self?.pay(cardToken: cardToken)
        }
    }
    
    // MARK: - Private Methods
    
    private func pay(cardToken: String) {
        deleteAllCards { [weak self] (isDone: Bool, error: CMError?) in
            if !isDone {
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            self?.performPayment(cardToken: cardToken)
        }
    }
    
    private func performPayment(cardToken: String) {
        isLoading.value = true
        
        let request = PaymentRequest(token: cardToken, orderId: orderId)
        
        service.performPayment(request: request) { [weak self] (response: PaymentResponse?, error: CMError?) in
            self?.isLoading.value = false
            
            if let error = error {
                self?.status.value = .error(error: error.localizedDescription)
                
                return
            }
            
            guard let response = response else {
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            if response.isPaymentDone {
                self?.status.value = .paymentReady
            } else {
                self?.status.value = .error(error: response.errorMessage)
            }
        }
    }
    
    private func deleteAllCards(onComplete: @escaping (_ isDone: Bool, _ error: CMError?) -> Void) {
        isLoading.value = true
        
        service.deleteAllCards { [weak self] (isDone: Bool, error: CMError?) in
            self?.isLoading.value = true
            
            onComplete(isDone, error)
        }
    }
}
