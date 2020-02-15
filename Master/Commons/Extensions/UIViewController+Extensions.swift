//
//  UIViewController+Extensions.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import SideMenu

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
    
    func showError(message: String?) {
        NotificationBanner(title: "Error", subtitle: message, style: .danger).show()
    }
    
    func showWarning(message: String?) {
        NotificationBanner(title: "Error", subtitle: message, style: .warning).show()
    }
    
    func showMenu(router: RouterBase<HomeRouterTransitions>) {
        let menuVC = MenuViewController(router: router)
        
        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: menuVC)
        leftMenuNavigationController.setNavigationBarHidden(true, animated: false)
        leftMenuNavigationController.menuWidth = UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 4)
        leftMenuNavigationController.statusBarEndAlpha = 0
        
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        SideMenuManager.default.leftMenuNavigationController?.presentationStyle = .menuSlideIn
        SideMenuManager.default.leftMenuNavigationController?.presentationStyle.presentingEndAlpha = 0.5
        
        present(leftMenuNavigationController, animated: true, completion: nil)
    }
}
