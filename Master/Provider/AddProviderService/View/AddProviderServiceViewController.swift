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

protocol AddProviderServiceDelegate: class {
    func serviceAdded()
}

class AddProviderServiceViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var serviceImageTakenView: UIImageView!
    @IBOutlet private weak var serviceNameTextField: MTextField!
    @IBOutlet private weak var serviceDescView: UIView!
    @IBOutlet private weak var serviceDescTextField: MTextField!
    @IBOutlet private weak var servicePriceTextField: MTextField!
    @IBOutlet private weak var serviceCategoryTextField: MTextField!
    @IBOutlet private weak var serviceCategoryView: UIView!
    @IBOutlet private weak var serviceImageView: UIView!
    @IBOutlet private weak var uploadButton: UIButton!
    
    // MARK: - UI Actions
    @IBAction private func continueButtonAction() {
        validateFields { [weak self] in
            self?.viewModel.uploadImage(serviceImageTakenView) { (success, url) in
                if success {
                    self?.performPost(url: url)
                }
            }
        }
    }
    
    @IBAction private func legalButtonAction() {
        router.transition(to: .legal)
    }
    
    // MARK: - Properties
    private let router: RouterBase<ProviderRouterTransitions>
    private let viewModel: AddProviderServiceViewModel
    private var originalInset: UIEdgeInsets = .zero
    private var imagePicker: UIImagePickerController?
    private weak var delegate: AddProviderServiceDelegate?
    
    // MARK: - Life Cycle
    init(router: RouterBase<ProviderRouterTransitions>,
         viewModel: AddProviderServiceViewModel,
         delegate: AddProviderServiceDelegate?) {
        
        self.router = router
        self.viewModel = viewModel
        self.delegate = delegate

        super.init(nibName: String(describing: AddProviderServiceViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder init not implemented.")
    }
    
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
    private func performPost(url: String) {
        viewModel.postProviderService(url: url,
                                      name: serviceNameTextField.safeText,
                                      price: getValueFromFormattedCurrency(),
                                      desc: serviceDescTextField.safeText)
    }
    
    private func getValueFromFormattedCurrency() -> Double {
        guard let regex = try? NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive) else {
            return 0
        }
        
        let count = servicePriceTextField.safeText.count
        let cleanValue = regex.stringByReplacingMatches(in: servicePriceTextField.safeText,
                                                        options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                        range: NSRange(location: 0, length: count),
                                                        withTemplate: "")
        
        return Double(cleanValue) ?? 0
    }
    
    private func setupUI() {
        // FIXME
        title = "Agregar Servicio"
        
        uploadButton.isEnabled = false
        
        setupBindings()
        
        originalInset = scrollView.contentInset
        serviceImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(serviceImageTapped)))
        
        serviceCategoryView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                        action: #selector(serviceCategoryTapped)))
        
        serviceDescView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                    action: #selector(serviceDescTapped)))
        
        setupKeyboardListeners()
        disableTitle()
        addIconInNavigationBar()
        enableKeyboardDismiss()
        
        servicePriceTextField.addTarget(self, action: #selector(priceFieldEditingChanged), for: .editingChanged)
    }
    
    private func setupBindings() {
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
        
        viewModel.status.listen { [weak self] status in
            switch status {
            case .error(let error):
                self?.showError(message: error)
                
            case .postSuccessful:
                self?.navigationController?.popViewControllerWithHandler { [weak self] in
                    self?.delegate?.serviceAdded()
                }
                
            default:
                return
            }
        }
        
        viewModel.placeholderRemoved.bindTo(uploadButton, to: .state)
    }
    
    private func validateFields(onValidBlock: () -> Void) {
        // FIXME: Hardcoded strings
        
        if serviceNameTextField.safeText.count <= 2 {
            showWarning(message: "Ingresa un nombre de servicio válido.")
            
            return
        }
        
        if servicePriceTextField.safeText.isEmpty {
            showWarning(message: "Ingresa un precio de servicio válido.")
            
            return
        }
        
        if serviceDescTextField.safeText.count <= 2 {
            showWarning(message: "Ingresa una descripción del servicio válida.")
            
            return
        }
        
        if serviceDescTextField.safeText.count >= 100 {
            showWarning(message: "La descripción del servicio es muy larga.")
            
            return
        }
        
        if serviceCategoryTextField.safeText.isEmpty {
            showWarning(message: "Selecciona una categoría para tu servicio.")
            
            return
        }
        
        onValidBlock()
    }
    
    @objc func serviceDescTapped() {
        let textViewModel = viewModel.getCompleteTextViewModel(savedValue: serviceDescTextField.text)
        
        router.transition(to: .completeText(viewModel: textViewModel, delegate: self))
    }
    
    @objc private func priceFieldEditingChanged() {
        if let amountString = servicePriceTextField.text?.currencyInputFormatting() {
            servicePriceTextField.text = amountString
        }
    }
    
    @objc private func serviceCategoryTapped() {
        router.transition(to: .listSelector(viewModel: viewModel.getListSelectorViewModel(),
                                            delegate: self))
    }
    
    @objc private func serviceImageTapped() {
        let style: UIAlertController.Style = UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet
        
        // FIXME: Strings
        let dialog = UIAlertController(title: "Foto del servicio", message: "Selecciona un medio para la foto", preferredStyle: style)
        
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
            viewModel.placeholderRemoved.value = true
            serviceImageTakenView.image = info[.originalImage] as? UIImage
        }
    }
}

fileprivate extension String {
    func currencyInputFormatting() -> String {
        
        var number: NSNumber?
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_CO")
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        guard let regex = try? NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive) else {
            return ""
        }
        
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix,
                                                          options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                          range: NSRange(location: 0, length: count),
                                                          withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double))
        
        // if first number is 0 or all numbers were deleted
        guard let formattedNumber = number, formattedNumber != (0 as NSNumber) else {
            return ""
        }
        
        return formatter.string(from: formattedNumber) ?? ""
    }
}

// MARK: - ListSelectorViewControllerDelegate
extension AddProviderServiceViewController: ListSelectorViewControllerDelegate {
    func optionSelectedAt(index: Int, option: ListItemProtocol) {
        serviceCategoryTextField.text = option.value
        viewModel.categoryId = (option.identifier as? Int) ?? viewModel.categoryId
    }
}

// MARK: - CompleteTextViewDelegate
extension AddProviderServiceViewController: CompleteTextViewDelegate {
    func continueButtonTapped(viewModel: CompleteTextViewModel) {
        serviceDescTextField.text = viewModel.value
    }
}
