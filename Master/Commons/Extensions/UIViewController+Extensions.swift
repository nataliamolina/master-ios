//
//  UIViewController+Extensions.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit
import NotificationBannerSwift

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
        NotificationBanner(title: "Master", subtitle: message, style: .success).show()
    }
    
    func showError(message: String?) {
        NotificationBanner(title: "Error", subtitle: message, style: .danger).show()
    }
    
    func showWarning(title: String = "Error", message: String?) {
        NotificationBanner(title: title, subtitle: message, style: .warning).show()
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
