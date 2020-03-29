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
    @IBOutlet private weak var loginButton: MButton!
    
    // MARK: - IBActions
    @IBAction private func loginButtonAction() {
        dismissKeyboard()
        viewModel.login(email: emailTextField.safeText,
                        password: passwordTextField.safeText)
    }
    
    @IBAction private func legalButtonAction() {
        dismissKeyboard()
        router.transition(to: .legal)
    }
    
    // MARK: - Properties
    private let viewModel: EmailLoginViewModel
    private let router: RouterBase<MainRouterTransitions>
    
    // MARK: - Life Cycle
    init(router: RouterBase<MainRouterTransitions>, viewModel: EmailLoginViewModel) {
        self.router = router
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: EmailLoginViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = viewModel.title
        
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
        
        viewModel.controlsEnabled.bindTo(emailTextField, to: .state)
        viewModel.controlsEnabled.bindTo(passwordTextField, to: .state)
        viewModel.controlsEnabled.bindTo(loginButton, to: .state)
        
        viewModel.status.listen { [weak self] status in
            guard let self = self else { return }
            
            switch status {
            case .loginReady:
                self.router.transition(to: .backToPresenter)
                
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
extension EmailLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTextfieldSwitch(fieldsHolder: mainStackview, textField: textField) { [weak self] in
            self?.dismissKeyboard()
            self?.loginButtonAction()
        }
        
        return true
    }
}