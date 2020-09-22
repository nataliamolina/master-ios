//
//  ExcessViewController.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 9/21/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol ExcessViewControllerDelegate: class {
    func saveExcess(price: Double, description: String)
}
class ExcessViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var radioView: UIView!
    @IBOutlet private weak var excessStackView: UIStackView!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextView!
    @IBOutlet private weak var descriptionView: UIView!
    @IBOutlet private weak var dialogView: UIView!
    @IBOutlet private weak var dialogViewConstraint: NSLayoutConstraint!
    
    private weak var delegate: ExcessViewControllerDelegate?
    
    // MARK: - UI Actions
    @IBAction private func cancelAction() {
        if let navbarController = navigationController {
            navbarController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction private func saveAction() {
        let price = Double(descriptionTextField.text ?? "0") ?? 0
        delegate?.saveExcess(price: price, description: "")
    }
    
    // MARK: - Life Cycle
    init(delegate: ExcessViewControllerDelegate?) {
        self.delegate = delegate
        
        super.init(nibName: String(describing: ExcessViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismissKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        applyGradient()
    }
    
    private func setupUI() {
        let radio: RadioView = .fromNib()
        radio.setupWith(name: "orderExcess.message".localized, isSelected: false, index: 0)
        radio.onTappedBlock = { [weak self] _ in
            self?.excessStackView.isHidden = false
        }
        radioView.addSubview(radio)
        
        setupKeyboardListeners()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(dismissAction)))
    }
    
    @objc private func dismissAction() {
        dismissKeyboard()
    }
    
    private func applyGradient() {
        descriptionView.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach {
            $0.removeFromSuperlayer()
        }
        
        descriptionView.layer.cornerRadius = 12
        descriptionView.clipsToBounds = true
        
        applyGradientTo(imageView: descriptionView, colors: [UIColor.Master.green.cgColor, UIColor.Master.green.cgColor])
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
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let frame = (UIScreen.main.bounds.height - dialogView.frame.height)/2
        
        dialogViewConstraint.constant = keyboardSize.height - frame
    }
    
    @objc private func keyboardWillHide() {
        dialogViewConstraint.constant = 0
    }
    
    private func applyGradientTo(imageView: UIView,
                                 colors: [CGColor],
                                 cornerRadius: CGFloat? = 12,
                                 lineWidth: CGFloat = 2) {
        
        let gradient = CAGradientLayer()
        let cornerRadius = cornerRadius ?? imageView.frame.size.width / 2
        
        gradient.frame =  CGRect(origin: .zero, size: imageView.frame.size)
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.colors = colors
        
        imageView.layer.cornerRadius = cornerRadius
        
        let bezierPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: cornerRadius).cgPath
        
        let shape = CAShapeLayer()
        shape.lineWidth = lineWidth
        shape.path = bezierPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        imageView.layer.addSublayer(gradient)
    }
}
