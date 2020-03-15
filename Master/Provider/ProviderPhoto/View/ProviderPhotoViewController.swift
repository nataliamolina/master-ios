//
//  ProviderPhotoViewController.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import MobileCoreServices

class ProviderPhotoViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var photoView: UIView!
    @IBOutlet private weak var uploadButton: UIButton!
    
    // MARK: - UI Actions
    @IBAction private func uploadButtonAction() {
        viewModel.uploadImage(photoImageView)
    }
    
    @IBAction private func legalButtonAction() {
        router.transition(to: .legal)
    }
    
    // MARK: - Properties
    private let viewModel: ProviderPhotoViewModel
    private let router: RouterBase<ProviderRouterTransitions>
    private var imagePicker: UIImagePickerController?
    
    // MARK: - Life Cycle
    
    init(viewModel: ProviderPhotoViewModel, router: RouterBase<ProviderRouterTransitions>) {
        self.viewModel = viewModel
        self.router = router
        
        super.init(nibName: String(describing: ProviderPhotoViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        uploadButton.isEnabled = false
        
        // FIXME: Hardcoded title
        title = "Foto de perfil"
        disableTitle()
        addIconInNavigationBar()
        
        photoImageView.layer.borderWidth = 2
        photoImageView.layer.borderColor = UIColor.Master.green.cgColor
        
        photoView.isUserInteractionEnabled = true
        photoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showSourceSelector)))
        
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
        
        viewModel.status.listen { [weak self] status in
            switch status {
            case .error(let error):
                self?.showError(message: error)
                
            case .uploadSuccessful:
                self?.router.transition(to: .home)
                
            default:
                return
            }
        }
        
        viewModel.placeholderRemoved.bindTo(uploadButton, to: .state)
    }
    
    @objc private func showSourceSelector() {
        // FIXME: Strings
        let dialog = UIAlertController(title: "Foto de perfil", message: "Selecciona un medio para tu foto", preferredStyle: .actionSheet)
        
        dialog.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { [weak self] _ in
            self?.openPhotoPicker()
        }))
        
        dialog.addAction(UIAlertAction(title: "Galería de fotos", style: .default, handler: { [weak self] _ in
            self?.openGallery()
        }))
        
        dialog.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        present(dialog, animated: true, completion: nil)
    }
    
    private func openPhotoPicker() {
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode =  .photo
        imagePicker?.allowsEditing = true
        imagePicker?.cameraDevice = .front
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func openGallery() {
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .photoLibrary
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProviderPhotoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        imagePicker?.dismiss(animated: true, completion: nil)
        
        if info.keys.contains(.originalImage) {
            viewModel.placeholderRemoved.value = true
            photoImageView.image = info[.originalImage] as? UIImage
        }
    }
}
