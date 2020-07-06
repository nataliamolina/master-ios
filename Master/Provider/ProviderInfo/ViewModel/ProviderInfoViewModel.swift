//
//  ProviderInfoViewModel.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/5/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

class ProviderInfoViewModel {
    var info: ProviderInfoModel
    
    private let service: ProviderInfoServiceModelProtocol
    
    
    init(info: ProviderInfoModel,
         service: ProviderInfoServiceModelProtocol? = nil ) {
        let defaultService = ProviderInfoService(connectionDependency: ConnectionManager())
        self.service = defaultService
        self.info = info
    }
    
    func saveInfo() {
        service.postProviderInfo(request: getRequest()) { (result, error) in
            <#code#>
        }
    }
    
    func getRequest() -> ProviderInfoServiceModelRequest {
        return ProviderInfoServiceModelRequest(dataType: info.dataType,
                                               position: info.position,
                                               location: info.location,
                                               startDate: info.startDate,
                                               endDate: info.endDate,
                                               isCurrent: info.isCurrent,
                                               country: info.country,
                                               city: info.city)
    }
    
   /*
     service.fetchProviderOrders { [weak self] (response: [Order], error: CMError?) in
         
         guard error == nil else {
             self?.isLoading.value = false
             
             return
         }
         
         self?.ordersToViewModels(models: response)
         self?.fetchProviderInfo()
     }
     */
}
