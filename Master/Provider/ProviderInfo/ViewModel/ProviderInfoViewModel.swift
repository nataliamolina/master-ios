//
//  ProviderInfoViewModel.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/5/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum ProviderInfoServiceViewModelStatus {
    case undefined
    case error(error: String?)
    case postSuccessful(info: [ProviderInfoServiceModel])
    case putSuccessful(info: [ProviderInfoServiceModel])
}
class ProviderInfoViewModel {
    var info: ProviderInfoModel
    let status = Var<ProviderInfoServiceViewModelStatus>(.undefined)
    let isLoading = Var(false)
    
    private let service: ProviderInfoServiceModelProtocol
    
    init(info: ProviderInfoModel,
         service: ProviderInfoServiceModelProtocol? = nil ) {
        let defaultService = ProviderInfoService(connectionDependency: ConnectionManager())
        self.service = defaultService
        self.info = info
    }
    
    func saveInfo() {
        guard let id = info.id, id != 0 else {
            postInfo()
            return
        }
        putInfo()
    }
    
    private func postInfo() {
        loadingState(true)
        service.postProviderInfo(request: getRequest()) { [weak self] (result, error) in
            self?.loadingState(false)
            
            if let error = error {
                self?.status.value = .error(error: error.error)
                
                return
            }
            
            self?.status.value = .postSuccessful(info: result ?? [])
        }
    }
    
    private func putInfo() {
        loadingState(true)
        service.putProviderInfo(request: getRequestPut()) { [weak self] (result, error) in
            self?.loadingState(false)
            
            if let error = error {
                self?.status.value = .error(error: error.error)
                
                return
            }
            
            self?.status.value = .putSuccessful(info: result ?? [])
        }
    }
    
    private func getRequest() -> ProviderInfoServiceModelRequest {
        return ProviderInfoServiceModelRequest(dataType: info.dataType.rawValue,
                                               position: info.position,
                                               location: info.location,
                                               startDate: info.startDate,
                                               endDate: info.endDate,
                                               isCurrent: info.isCurrent,
                                               country: info.country,
                                               city: info.city)
    }
    
    private func getRequestPut() -> ProviderInfoServiceModel {
        return ProviderInfoServiceModel(id: info.id ?? 0,
                                        dataType: info.dataType.rawValue,
                                        position: info.position,
                                        location: info.location,
                                        startDate: info.startDate,
                                        endDate: info.endDate,
                                        isCurrent: info.isCurrent,
                                        country: info.country,
                                        city: info.city)
    }
    
    private func loadingState(_ state: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading.value = state
        }
    }
}
