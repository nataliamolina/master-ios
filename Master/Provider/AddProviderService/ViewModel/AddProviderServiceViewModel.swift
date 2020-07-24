//
//  AddProviderServiceViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 31/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum AddProviderServiceViewModelStatus {
    case undefined
    case error(error: String?)
    case postSuccessful
    case putSuccessful(providerService: ProviderService)
}

class AddProviderServiceViewModel {
    // MARK: - Properties
    private let uploader = ImageUploader()
    private let service: AddProviderServiceServiceProtocol
    private var serviceCategories = [ListItemProtocol]()
    var serviceModel: ProviderServiceModel
    
    var categoryId = 0
    let placeholderRemoved = Var(false)
    let status = Var<AddProviderServiceViewModelStatus>(.undefined)
    let isLoading = Var(false)
    
    // MARK: - Life Cycle
    init(serviceModel: ProviderServiceModel,
         service: AddProviderServiceServiceProtocol = AddProviderServiceService(connectionDependency: ConnectionManager())) {
        
        self.serviceModel = serviceModel
        self.service = service
        
        getServiceCategories()
    }
    
    // MARK: - Public Methods
    
    func uploadImage(_ image: UIImageView,
                     onCompletion: @escaping (_ success: Bool, _ url: String) -> Void) {
        
        loadingState(true)
        
        uploader.upload(image: image, name: Session.shared.profile.document, path: "providers/services")
        
        uploader.onCompleteBlock = { [weak self] (isDone: Bool, result: String?, error: String?) in
            self?.loadingState(false)
            
            onCompletion(isDone, result ?? "")
        }
    }
    
    func updateService(url: String, name: String, price: Double, desc: String) {
        let request = ProviderServiceRequest(photoUrl: url,
                                             name: name,
                                             price: price,
                                             description: desc,
                                             serviceCategoryId: categoryId)
        if serviceModel.id == nil {
            postProviderService(request: request)
        } else {
            putProviderService(request: request)
        }
        
    }
    
    func postProviderService(request: ProviderServiceRequest) {
        loadingState(true)
        
        service.postProviderService(request: request) { [weak self] (_, error: CMError?) in
            self?.loadingState(false)
            
            if let error = error {
                self?.status.value = .error(error: error.error)
                
                return
            }
            
            self?.status.value = .postSuccessful
        }
    }
    
    func putProviderService(request: ProviderServiceRequest) {
        guard let id = serviceModel.id else { return }
        
        loadingState(true)
        service.putProviderService(serviceId: id, request: request) { [weak self] (result: ProviderService?, error: CMError?) in
            self?.loadingState(false)
            
            if let error = error {
                self?.status.value = .error(error: error.error)
                
                return
            }
            
            guard let service = result else { return }
            
            self?.status.value = .putSuccessful(providerService: service)
        }
    }
        
    func getListSelectorViewModel() -> ListSelectorViewModel {
        return ListSelectorViewModel(title: nil, desc: nil, dataSource: serviceCategories)
    }
    
    func getCompleteTextViewModel(savedValue: String?) -> CompleteTextViewModel {
        // FIXME: Strings
        return CompleteTextViewModel(title: "Completa",
                                     desc: "Ingresa la descripción de tu servicio",
                                     placeholder: "",
                                     index: 0,
                                     savedValue: savedValue)
    }
    
    // MARK: - Private Methods
    
    private func getServiceCategories() {
        service.getServiceCategories { [weak self] (response: [ServiceCategory]?, _) in
            self?.serviceCategoriesToItems(response ?? [])
        }
    }
    
    private func serviceCategoriesToItems(_ models: [ServiceCategory]) {
        serviceCategories = models.map {
            ListItem(value: $0.name, identifier: $0.id)
        }
    }
    
    private func loadingState(_ state: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading.value = state
        }
    }
}
