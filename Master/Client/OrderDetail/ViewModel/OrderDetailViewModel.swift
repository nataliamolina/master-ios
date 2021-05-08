//
//  OrderDetailViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import EasyBinding

enum OrderDetailViewModelStatus {
    case undefined
    case error(error: String?)
}

class OrderDetailViewModel {
    // MARK: - Properties
    private var cart = [OrderProviderService]()
    private var model: Order?
    private let service: OrderDetailServiceProtocol
    private let orderId: Int
    private typealias CheckoutLang = CheckoutConstants.Lang
    private var providerName: String

    let formattedTotal = Var("$0")
    let status = Var<OrderDetailViewModelStatus>(.undefined)
    let isLoading = Var(false)
    let dataSource = Var<[CellViewModelProtocol]>([])
    let pendingPayment = Var<Bool>(true)
    let needsToRateOrder = Var(false)
    
    // MARK: - Life Cycle
    init(orderId: Int, service: OrderDetailServiceProtocol? = nil, providerName: String = "") {
        let defaultService = OrderDetailService(connectionDependency: ConnectionManager())
        
        self.orderId = orderId
        self.service = service ?? defaultService
        self.providerName = providerName
    }
    
    // MARK: - Public Methods
    
    func fetchDetail() {
        isLoading.value = true
        
        service.fetchOrderDetailBy(id: orderId) { [weak self] (response: Order?, error: CMError?) in
            guard let self = self else {
                return
            }
            
            self.isLoading.value = false
            
            guard let model = response, error == nil else {
                self.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            self.cart = model.orderProviderServices ?? []
            self.pendingPayment.value = !(model.orderState.type == .pendingForPayment)
            self.responseToViewModels(model: model)
            self.fetchOrderServices()
            
            if model.orderState.type == .finished {
                self.validateOrderRating()
            }
        }
    }
    
    func getChatViewModel() -> ChatViewModel {
        let name: String = model?.provider.user.names ?? ""
        
        return ChatViewModel(chatId: (model?.id ?? 0).asString,
                             userId: (model?.user.id ?? 0).asString,
                             photoUrl: model?.provider.photoUrl ?? "",
                             name: !name.isEmpty ? name : providerName,
                             sentToToken: model?.provider.user.pushToken ?? "",
                             sentTo: .chatProvider)
    }
    
    func getViewModelAt(indexPath: IndexPath) -> CellViewModelProtocol? {
        return dataSource.value.safeContains(indexPath.row)
    }
    
    func getPaymentViewModel() -> PaymentViewModel {
        return PaymentViewModel(orderId: orderId,
                                formattedTotal: formattedTotal.value,
                                userId: Session.shared.profile.id,
                                userEmail: Session.shared.profile.email)
    }
    
    func getRateViewModel() -> RateViewModel {
        return RateViewModel(orderId: orderId)
    }
    
    // MARK: - Private Methods
    
    private func responseToViewModels(model: Order) {
        dataSource.value.removeAll()
        self.model = model

        self.formattedTotal.value = (model.grossTotal + (model.extraCost ?? 0)).toFormattedCurrency()
        
        let headerViewModel = OrderDetailHeaderCellViewModel(orderId: model.id,
                                                             status: model.orderState.type,
                                                             providerName: model.provider.user.names,
                                                             orderDate: Utils.jsonToFormattedDate(model.orderDate),
                                                             isProvider: false)
        
        let fieldsCells = [
            CheckoutFieldCellViewModel(title: CheckoutLang.address,
                                       value: model.orderAddress,
                                       image: .gps,
                                       type: .address,
                                       detailIconVisible: false),
            
            CheckoutFieldCellViewModel(title: CheckoutLang.dateAndHour,
                                       value: Utils.jsonToFormattedDate(model.orderDate),
                                       image: .calendar,
                                       type: .dates,
                                       detailIconVisible: false),
            
            CheckoutFieldCellViewModel(title: CheckoutLang.notes, 
                                       value: model.notes.isEmpty ? "-" : model.notes,
                                       image: .note,
                                       type: .notes,
                                       detailIconVisible: false),
            
            CheckoutFieldCellViewModel(title: CheckoutLang.city,
                                       value: model.city?.name ?? "",
                                       image: .building,
                                       type: .city,
                                       detailIconVisible: false),
            
            CheckoutFieldCellViewModel(title: CheckoutLang.conditions,
                                       value: model.serviceRequirements ?? "-",
                                       image: .checkList,
                                       type: .city,
                                       detailIconVisible: false),
            
            CheckoutFieldCellViewModel(title: CheckoutLang.excess,
                                       value: (model.extraCost ?? 0).toFormattedCurrency(),
                                       image: .dollar,
                                       type: .excess,
                                       detailIconVisible: false),
            
            CheckoutFieldCellViewModel(title: CheckoutLang.description,
                                       value: model.extraCostDescription ?? "",
                                       image: .note,
                                       bottomLineVisible: false,
                                       type: .descExcess,
                                       detailIconVisible: false)
        ]
        
        dataSource.value.append(headerViewModel)
        dataSource.value.append(contentsOf: fieldsCells)
        
    }
    
    private func getCartCountTotal() -> Double {
        return Double(cart.map { $0.getId() }.reduce(0, +))
    }
    
    private func fetchOrderServices() {
        service.fetchOrderServices(id: orderId) { [weak self] (response: [OrderProviderService], error: CMError?) in
            
            guard error == nil else {
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            self?.orderServicesToViewModels(models: response)
        }
    }
    
    private func orderServicesToViewModels(models: [OrderProviderService]) {
        let products = models.map {
            ProviderServiceCellViewModel(productImageUrl: $0.getPhotoUrl() ?? "",
                                         productName: $0.getName(),
                                         productDesc: $0.getDescription(),
                                         productPrice: $0.getPrice(),
                                         productCount: 0,
                                         productId: $0.getId())
        }
        
        dataSource.value.append(contentsOf: getGroupedServices(models: products))
    }
    
    private func validateOrderRating() {
        service.validateOrderRating(id: orderId) { [weak self] (response: Bool, error: CMError?) in
            guard !response, error == nil else {
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            self?.needsToRateOrder.value = true
            self?.showRatingButton()
        }
    }
    
    private func showRatingButton() {
        guard var headerViewModel = dataSource.value.first as? OrderDetailHeaderCellViewModel else {
            return
        }
        
        headerViewModel.status = .ratingPending
        
        dataSource.value[0] = headerViewModel
    }
    
    private func getGroupedServices(models: [ProviderServiceCellViewModel]) -> [ProviderServiceCellViewModel] {
        var result = [ProviderServiceCellViewModel]()
        
        for index in models.indices {
            if let indexFound = result.firstIndex(where: { $0 == models[index] }) {
                result[indexFound].productCount += 1
            } else {
                result.append(models[index])
            }
        }
        
        return result
    }
}
