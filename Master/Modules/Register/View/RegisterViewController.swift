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
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var registerButton: MButton!
    
    // MARK: - IBActions
    @IBAction private func registerButtonAction() {
        dismissKeyboard()
        
        let firstName = namesTextField.safeText.components(separatedBy: " ").first ?? ""
        let lastName = namesTextField.safeText.components(separatedBy: " ").last ?? ""
        
        viewModel.register(email: emailTextField.safeText,
                           password: passwordTextField.safeText,
                           firstName: firstName,
                           lastName: lastName,
                           phoneNumber: phoneTextField.safeText)
    }
    
    // MARK: - Properties
    private let viewModel = RegisterViewModel()
    var router: RouterBase<MainRouterTransitions>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = viewModel.title
        viewModel.isLoading.bindTo(activityIndicator, to: .state)
        viewModel.controlsEnabled.bindTo(emailTextField, to: .state)
        viewModel.controlsEnabled.bindTo(passwordTextField, to: .state)
        viewModel.controlsEnabled.bindTo(phoneTextField, to: .state)
        viewModel.controlsEnabled.bindTo(namesTextField, to: .state)
        viewModel.controlsEnabled.bindTo(registerButton, to: .state)
        
        viewModel.status.observe = { [weak self] status in
            guard let self = self else { return }
            
            switch status {
            case .registerReady:
                self.router?.transition(to: .home)
                
            case .error(let error):
                self.showError(message: error)
                
            default:
                return
            }
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
