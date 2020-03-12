//
//  OrdersViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 29/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum OrdersViewModelStatus {
    case undefined
    case error(error: String?)
}

class OrdersViewModel {
    // MARK: - Properties
    let needsToShowEmptyState = Var(false)
    let status = Var<OrdersViewModelStatus>(.undefined)
    let isLoading = Var(false)
    let dataSource: Var<[CellViewModelProtocol]> = Var([])
    
    private let service: OrdersServiceProtocol
    
    // MARK: - Life Cycle
    init(service: OrdersServiceProtocol? = nil) {
        let defaultService = OrdersService(connectionDependency: ConnectionManager())
        
        self.service = service ?? defaultService
        
        addInitialViewModels()
        
        dataSource.listen { [weak self] dataSource in
            self?.needsToShowEmptyState.value = dataSource.count == 1
        }
    }
    
    // MARK: - Public Methods
    
    func fetchServices() {
        isLoading.value = true
        
        service.fetchOrders { [weak self] (response: [Order]?, error: CMError?) in
            self?.isLoading.value = false
            
            guard let models = response, error == nil else {
                return
            }
            
            self?.servicesToViewModels(models: models)
        }
    }
    
    func getViewModelAt(indexPath: IndexPath) -> CellViewModelProtocol? {
        return dataSource.value.safeContains(indexPath.row)
    }
    
    func getOrderDetailViewModel(with cellViewModel: OrderCellDataSource) -> OrderDetailViewModel {
        return OrderDetailViewModel(orderId: Int(cellViewModel.id) ?? 0)
    }
    
    // MARK: - Private Methods
    
    private func servicesToViewModels(models: [Order]) {
        dataSource.value.append(contentsOf: models.map {
            OrderCellViewModel(id: $0.id.asString,
                               providerName: $0.provider.user.names,
                               providerImageUrl: $0.provider.photoUrl,
                               orderTotal: $0.grossTotal,
                               orderCategory: $0.serviceCategory?.name ?? "-",
                               orderState: $0.orderState.type,
                               isLastItem: $0.id == models.last?.id)
        })
    }
    
    private func addInitialViewModels() {
        dataSource.value.append(TitleCellViewModel(title: "Pedidos"))
    }
}
