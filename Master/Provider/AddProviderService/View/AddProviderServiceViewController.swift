//
//  AddProviderServiceViewController.swift
//  Master
//
//  Created by Carlos Mejía on 30/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices

class AddProviderServiceViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var serviceImageTakenView: UIImageView!
    @IBOutlet private weak var serviceNameLabel: UITextField!
    @IBOutlet private weak var serviceDescLabel: UITextView!
    @IBOutlet private weak var servicePriceLabel: UITextField!
    @IBOutlet private weak var serviceCategoryLabel: UITextField!
    @IBOutlet private weak var serviceCategoryView: UIView!
    @IBOutlet private weak var serviceImageView: UIView!
    
    // MARK: - UI Actions
    @IBAction private func continueButtonAction() {
        
    }
    
    @IBAction private func legalButtonAction() {
        
    }
    
    // MARK: - Properties
    private var originalInset: UIEdgeInsets = .zero
    private var imagePicker: UIImagePickerController?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismissKeyboard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    private func setupUI() {
        originalInset = scrollView.contentInset
        serviceImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(serviceImageTapped)))
        
        setupKeyboardListeners()
        disableTitle()
        addIconInNavigationBar()
        enableKeyboardDismiss()
    }
    
    private func setupBindings() {
        
    }
    
    @objc private func serviceImageTapped() {
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
        Loader.show()
        
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode =  .photo
        imagePicker?.allowsEditing = true
        imagePicker?.cameraDevice = .front
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            Loader.dismiss()
            
            return
        }
        
        present(imagePicker, animated: true) {
            Loader.dismiss()
        }
    }
    
    private func openGallery() {
        Loader.show()
        
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .photoLibrary
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            Loader.dismiss()
            
            return
        }
        
        present(imagePicker, animated: true) {
            Loader.dismiss()
        }
    }
    
    private func setupKeyboardListeners() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification ,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification ,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        scrollView.contentInset = UIEdgeInsets(top: originalInset.top,
                                               left: originalInset.left,
                                               bottom: originalInset.bottom + (keyboardSize?.height ?? 0),
                                               right: originalInset.right)
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentInset = originalInset
        animateLayout()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddProviderServiceViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        imagePicker?.dismiss(animated: true, completion: nil)
        
        if info.keys.contains(.originalImage) {
            serviceImageTakenView.image = info[.originalImage] as? UIImage
        }
    }
}
