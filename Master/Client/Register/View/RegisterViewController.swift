//
//  RegisterViewController.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var mainStackview: UIStackView!
    @IBOutlet private weak var emailTextField: MTextField!
    @IBOutlet private weak var passwordTextField: MTextField!
    @IBOutlet private weak var phoneTextField: MTextField!
    @IBOutlet private weak var namesTextField: MTextField!
    @IBOutlet private weak var registerButton: MButton!
    
    // MARK: - IBActions
    @IBAction private func registerButtonAction() {
        dismissKeyboard()
        validateForm()
    }
    
    @IBAction private func legalButtonAction() {
        dismissKeyboard()
        router?.transition(to: .legal)
    }
    
    // MARK: - Properties
    private let viewModel = RegisterViewModel()
    var router: RouterBase<MainRouterTransitions>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    private func validateForm() {
        // FIXME: Messages
        if namesTextField.safeText.isEmpty || namesTextField.safeText.count < 3 {
            showWarning(message: "Debes ingresar un nombre válio.")
            
            return
        }
        
        if phoneTextField.safeText.isEmpty || passwordTextField.safeText.count < 6 {
            showWarning(message: "Debes ingresar un telefono valido..")
            
            return
        }
        
        if emailTextField.safeText.isEmpty || emailTextField.safeText.count < 11 || !emailTextField.safeText.contains("@") {
            showWarning(message: "Debes ingresar un correo válio.")
            
            return
        }
        
        if passwordTextField.safeText.isEmpty || passwordTextField.safeText.count < 4 {
            showWarning(message: "Debes ingresar una contraseña valida.")
            
            return
        }
        
        let firstName = namesTextField.safeText.components(separatedBy: " ").first ?? ""
        let lastName = namesTextField.safeText.components(separatedBy: " ").last ?? ""
        
        viewModel.register(email: emailTextField.safeText,
                           password: passwordTextField.safeText,
                           firstName: firstName,
                           lastName: lastName,
                           phoneNumber: phoneTextField.safeText)
    }
    
    private func setupUI() {
        title = viewModel.title
        viewModel.controlsEnabled.bindTo(emailTextField, to: .state)
        viewModel.controlsEnabled.bindTo(passwordTextField, to: .state)
        viewModel.controlsEnabled.bindTo(phoneTextField, to: .state)
        viewModel.controlsEnabled.bindTo(namesTextField, to: .state)
        viewModel.controlsEnabled.bindTo(registerButton, to: .state)
        
        viewModel.status.listen { [weak self] status in
            guard let self = self else { return }
            
            switch status {
            case .registerReady:
                self.router?.transition(to: .backToPresenter)
                
            case .error(let error):
                self.showError(message: error)
                
            default:
                return
            }
        }
        
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
        
        addIconInNavigationBar()
        
        enableKeyboardDismiss()
        
        enableFieldSwitch(fieldsHolder: mainStackview, delegate: self)
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTextfieldSwitch(fieldsHolder: mainStackview, textField: textField) { [weak self] in
            self?.dismissKeyboard()
            self?.registerButtonAction()
        }
        
        return true
    }
}
