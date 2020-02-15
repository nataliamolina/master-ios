//
//  MTextField.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit

class MTextField: UITextField {
    // MARK: - UI References
    @IBInspectable var showToggler: Bool = false
    
    // MARK: - Properties
    private var toggleButton = UIButton()
    
    var safeText: String {
        return text ?? ""
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if showToggler {
            addToggleButton()
        }
        
        setupStlye()
    }
    
    // MARK: - Private Methods
    private func setupStlye() {
        borderStyle = .none
        layer.backgroundColor = UIColor.white.cgColor
        layer.masksToBounds = false
        layer.shadowColor = UIColor.Master.green.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
    }
    
    private func addToggleButton() {
        addImageButton(image: .closedEye)
    }
    
    private func addImageButton(image: UIImage?) {
        rightView = nil
        
        toggleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        toggleButton.setImage(image, for: .normal)
        toggleButton.addTarget(self, action: #selector(togglePassword), for: .touchUpInside)
        
        rightViewMode = .always
        rightView = toggleButton
    }
    
     @objc private func togglePassword() {
        addImageButton(image: isSecureTextEntry ? .openEye : .closedEye)
        
        isSecureTextEntry.toggle()
    }
}
