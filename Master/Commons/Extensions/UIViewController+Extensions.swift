//
//  UIViewController+Extensions.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit
import SPAlert

extension UIViewController {
    func addIconInNavigationBar() {
        let rightImage = UIBarButtonItem(image: .greenLogoIcon, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = rightImage
    }
    
    func enableKeyboardDismiss() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func enableFieldSwitch(fieldsHolder: UIView, delegate: UITextFieldDelegate) {
        let textFieldsInView = fieldsHolder.subviews.filter { $0 is UITextField }
        
        for (index, view) in textFieldsInView.enumerated() {
            view.tag = index
            (view as? UITextField)?.delegate = delegate
        }
    }
    
    func handleTextfieldSwitch(fieldsHolder: UIView,
                               textField: UITextField,
                               onNoTextFieldsLeft: (() -> Void)? = nil) {
        
        let nextTag = textField.tag + 1
        
        guard let nextTextField = fieldsHolder.subviews.filter({ $0.tag == nextTag }).first else {
            onNoTextFieldsLeft?()
            
            return
        }
        
        nextTextField.becomeFirstResponder()
    }
    
    func showSuccess(message: String?) {
        SPAlert.present(title: "Master", message: message ?? "", preset: .done)
    }
    
    func showError(message: String?) {
        SPAlert.present(title: "Master", message: message ?? "", preset: .error)
    }
    
    func showWarning(title: String = "Error", message: String?) {
        SPAlert.present(title: "Master", message: message ?? "", preset: .exclamation)
    }
    
    func disableTitle() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        
        navigationItem.titleView = imageView
    }
    
    func animateLayout() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
