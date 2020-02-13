//
//  EmailLoginViewController.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit
import Hero

class EmailLoginViewController: UIViewController { 
    // MARK: - UI References
    @IBOutlet private weak var mainStackview: UIStackView!
    @IBOutlet private weak var emailTextField: MTextField!
    @IBOutlet private weak var passwordTextField: MTextField!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loginButton: MButton!
    
    // MARK: - IBActions
    @IBAction private func loginButtonAction() {
        viewModel.login(email: emailTextField.safeText,
                        password: passwordTextField.safeText)
    }
    
    // MARK: - Properties
    private let viewModel = EmailLoginViewModel()
    var router: RouterBase<MainRouterTransitions>?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = viewModel.title
        viewModel.isLoading.bindTo(activityIndicator)
        
        viewModel.status.valueDidChange = { [weak self] status in
            guard let self = self else { return }
            
            switch status {
            case .loginReady:
                self.router?.transition(to: .home(router: HomeRouter(rootViewController: self)))
                
            case .error(let error):
                self.showError(message: error)
                
            default:
                return
            }
        }
        
        addIconInNavigationBar()
        
        loginButton.style = .green
        
        enableKeyboardDismiss()
        
        enableFieldSwitch(fieldsHolder: mainStackview, delegate: self)
    }
}

// MARK: - UITextFieldDelegate
extension EmailLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTextfieldSwitch(fieldsHolder: mainStackview, textField: textField) { [weak self] in
            self?.dismissKeyboard()
        }
        
        return true
    }
}
