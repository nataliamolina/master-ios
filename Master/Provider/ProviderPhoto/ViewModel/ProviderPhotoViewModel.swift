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
}

class ProviderPhotoViewModel {
    // MARK: - Properties
    private let uploader = ImageUploader()
    private let service: ProviderPhotoServiceProtocol
    
    let placeholderRemoved = Var(false)
    let status = Var<ProviderPhotoViewModelStatus>(.undefined)
    let isLoading = Var(false)
    
    // MARK: - Life Cycle
    init(service: ProviderPhotoServiceProtocol = ProviderPhotoService(connectionDependency: ConnectionManager())) {
        self.service = service
        
        uploader.onCompleteBlock = { [weak self] (isDone: Bool, result: String?, error: String?) in
            self?.loadingState(false)
            
            if isDone {
                self?.updateProviderPhoto(url: result ?? "")
            } else {
                self?.status.value = .error(error: String.Lang.generalError)
                print(error ?? "")
            }
        }
    }
    
    // MARK: - Public Methods
    
    func uploadImage(_ image: UIImageView) {
        loadingState(true)
        
        uploader.upload(image: image, name: Session.shared.profile.document, path: "providers/profilePictures")
    }
    
    // MARK: - Private Methods
    
    private func updateProviderPhoto(url: String) {
        loadingState(true)
        
        let request = ProviderPhotoRequest(photoUrl: url)
        
        service.updatePhoto(request: request) { [weak self] (_, error: CMError?) in
            self?.loadingState(false)
            
            if let error = error {
                self?.status.value = .error(error: error.error)
                
                return
            }
            
            self?.status.value = .uploadSuccessful
        }
    }
    
    private func loadingState(_ state: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading.value = state
        }
    }
}
