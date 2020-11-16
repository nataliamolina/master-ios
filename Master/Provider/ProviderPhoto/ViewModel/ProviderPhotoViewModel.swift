//
//  ProviderPhotoViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

enum ProviderPhotoViewModelStatus {
    case undefined
    case error(error: String?)
    case uploadSuccessful
    case editImage
}

class ProviderPhotoViewModel {
    // MARK: - Properties
    private let uploader = ImageUploader()
    private let service: ProviderPhotoServiceProtocol
    private let edited: Bool
    
    let placeholderRemoved = Var(false)
    let status = Var<ProviderPhotoViewModelStatus>(.undefined)
    let isLoading = Var(false)
    
    // MARK: - Life Cycle
    init(service: ProviderPhotoServiceProtocol = ProviderPhotoService(connectionDependency: ConnectionManager()), edited: Bool = false) {
        self.service = service
        self.edited = edited
        
        uploader.onCompleteBlock = { [weak self] (isDone: Bool, result: String?, error: String?) in
            self?.loadingState(false)
            
            guard isDone else {
                self?.status.value = .error(error: String.Lang.generalError)
                return
            }
            
            guard edited else {
                self?.updateProviderPhoto(url: result ?? "")
                return
            }
            
            guard let urlString = result, urlString != self?.getPhotoUrl() else {
                self?.status.value = .editImage
                return
            }
            
            self?.updateProviderPhoto(url: result ?? "", status: .editImage)
        }
    }
    
    // MARK: - Public Methods
    
    func uploadImage(_ image: UIImageView) {
        loadingState(true)
        
        uploader.upload(image: image, name: Session.shared.profile.document, path: "providers/profilePictures")
    }
    
    func getPhotoUrl() -> String? {
        return Session.shared.provider?.photoUrl ?? nil
    }
    
    func getProvider() -> ProviderProfile? {
        return Session.shared.provider
    }
    
    // MARK: - Private Methods
    
    private func updateProviderPhoto(url: String, status: ProviderPhotoViewModelStatus = .uploadSuccessful) {
        loadingState(true)
        
        let request = ProviderPhotoRequest(photoUrl: url)
        
        service.updatePhoto(request: request) { [weak self] (_, error: CMError?) in
            self?.loadingState(false)
            
            if let error = error {
                self?.status.value = .error(error: error.error)
                
                return
            }
            
            self?.status.value = status
        }
    }
    
    private func loadingState(_ state: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading.value = state
        }
    }
}
