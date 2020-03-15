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
    
    // MARK: - UI Actions
    @IBAction private func uploadButtonAction() {
    }
    
    // MARK: - Properties
    private var imagePicker: UIImagePickerController?
    
    // MARK: - Life Cycle
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
        disableTitle()
        addIconInNavigationBar()
        
        photoImageView.layer.borderWidth = 2
        photoImageView.layer.borderColor = UIColor.Master.green.cgColor
        
        photoView.isUserInteractionEnabled = true
        photoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showSourceSelector)))
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
            photoImageView.image = info[.originalImage] as? UIImage
        }
    }
}
