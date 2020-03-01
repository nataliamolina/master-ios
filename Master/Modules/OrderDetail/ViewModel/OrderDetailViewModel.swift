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
    private let service: OrderDetailServiceProtocol
    private typealias CheckoutLang = CheckoutConstants.Lang
    private let orderId: Int
    
    let status = Var<OrderDetailViewModelStatus>(.undefined)
    let isLoading = Var(false)
    let dataSource = Var<[CellViewModelProtocol]>([])
    
    // MARK: - Life Cycle
    init(orderId: Int, service: OrderDetailServiceProtocol? = nil) {
        let defaultService = OrderDetailService(connectionDependency: ConnectionManager())
        
        self.orderId = orderId
        self.service = service ?? defaultService
    }
    
    // MARK: - Public Methods
    
    func fetchDetail() {
        isLoading.value = true
        
        service.fetchOrderDetailBy(id: orderId) { [weak self] (response: Order?, error: CMError?) in
            self?.isLoading.value = false
            
            guard let model = response, error == nil else {
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            self?.cart = model.orderProviderServices ?? []
            self?.responseToViewModels(model: model)
            self?.validateOrderRating()
            self?.fetchOrderServices()
        }
    }
    
    func getViewModelAt(indexPath: IndexPath) -> CellViewModelProtocol? {
        return dataSource.value.safeContains(indexPath.row)
    }
    
    // MARK: - Private Methods
    
    private func responseToViewModels(model: Order) {
        let headerViewModel = OrderDetailHeaderCellViewModel(orderId: model.id,
                                                             status: model.orderState.type,
                                                             providerName: model.provider.user.names,
                                                             orderDate: Utils.jsonToFormattedDate(model.orderDate))
        
        let fieldsCells = [
            CheckoutFieldCellViewModel(title: CheckoutLang.address, value: "", image: .gps, type: .address),
            CheckoutFieldCellViewModel(title: CheckoutLang.city, value: CheckoutLang.bogota, image: .building, type: .city),
            CheckoutFieldCellViewModel(title: CheckoutLang.dateAndHour, value: "", image: .calendar, type: .dates),
            CheckoutFieldCellViewModel(title: CheckoutLang.notes, value: "", image: .note, type: .notes),
            
            CheckoutFieldCellViewModel(title: CheckoutLang.products,
                                       value: CheckoutLang.cartTotal(getCartCountTotal()),
                                       image: .cart,
                                       bottomLineVisible: false,
                                       type: .cart)
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
        
        dataSource.value.append(contentsOf: products)
    }
    
    private func validateOrderRating() {
        service.validateOrderRating(id: orderId) { [weak self] (response: Bool, error: CMError?) in
            guard error == nil else {
                self?.status.value = .error(error: error?.localizedDescription)
                
                return
            }
            
            print(response)
        }
    }
}
