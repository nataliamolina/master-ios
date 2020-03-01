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
    static var needsToOpenOrders = false
    let status = Var<OrdersViewModelStatus>(.undefined)
    let isLoading = Var(false)
    let dataSource: Var<[CellViewModelProtocol]> = Var([])
    
    private let service: OrdersServiceProtocol
    
    // MARK: - Life Cycle
    init(service: OrdersServiceProtocol? = nil) {
        let defaultService = OrdersService(connectionDependency: ConnectionManager())
        
        self.service = service ?? defaultService
        
        addInitialViewModels()
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
    
    // MARK: - Private Methods
    
    private func servicesToViewModels(models: [Order]) {
      
    }
    
    private func addInitialViewModels() {
        dataSource.value.append(TitleCellViewModel(title: "Pedidos"))
    }
}
