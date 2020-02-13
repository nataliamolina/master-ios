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
    @IBAction private func loginButtonAction() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = "Registro"
        
        registerButton.style = .green
        
        enableKeyboardDismiss()
        
        enableFieldSwitch(fieldsHolder: mainStackview, delegate: self)
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTextfieldSwitch(fieldsHolder: mainStackview, textField: textField) { [weak self] in
            self?.dismissKeyboard()
        }
        
        return true
    }
}
