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
        loadingState(true)
        
        deleteAllCards { [weak self] (isDone: Bool, error: CMError?) in
            
            if !isDone {
                self?.loadingState(false)
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            self?.pay(card)
        }
        
    }
    
    // MARK: - Private Methods
    
    private func pay(_ card: PaymentezCard) {
        
        SDK.add(card, uid: userId, email: userEmail) { [weak self] (error: PaymentezSDKError?, card: PaymentezCard?) in
            
            guard let card = card, let cardToken = card.token else {
                self?.loadingState(false)
                // FIXME: String
                self?.status.value = .error(error: "Ocurrió un error al validar tu tarjeta, por favor intenta nuevamente.")
                
                return
            }
            
            self?.performPayment(cardToken: cardToken)
        }
    }
    
    private func performPayment(cardToken: String) {
        
        let request = PaymentRequest(token: cardToken, orderId: orderId)
        
        service.performPayment(request: request) { [weak self] (response: PaymentResponse?, error: CMError?) in
            self?.loadingState(false)
            
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
        loadingState(true)
        
        service.deleteAllCards { [weak self] (isDone: Bool, error: CMError?) in
            self?.loadingState(false)
            
            onComplete(isDone, error)
        }
    }
    
    private func loadingState(_ state: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading.value = state
        }
    }
}
