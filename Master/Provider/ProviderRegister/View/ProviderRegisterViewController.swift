//
//  ProviderRegisterViewController.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

enum ProviderRegisterIdentifiers: String {
    case city
    case bankType
}

class ProviderRegisterViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var documentTextField: MTextField!
    @IBOutlet private weak var bankNumberTextField: MTextField!
    @IBOutlet private weak var bankNameTextField: MTextField!
    @IBOutlet private weak var bankTypeTextField: MTextField!
    @IBOutlet private weak var bankTypeView: UIView!
    @IBOutlet private weak var aboutTextView: MTextField!
    @IBOutlet private weak var aboutView: UIView!
    
    @IBOutlet private weak var cityTextField: MTextField!
    @IBOutlet private weak var cityView: UIView!
    
    // MARK: - UI Actions
    @IBAction private func registerButtonAction() {
        validateForm()
    }
    
    @IBAction private func legalButtonAction() {
        router.transition(to: .legal)
    }
    
    // MARK: - Properties
    private var originalInset: UIEdgeInsets = .zero
    private let viewModel: ProviderRegisterViewModel
    private let router: RouterBase<ProviderRouterTransitions>
    
    // MARK: - Life Cycle
    init(router: RouterBase<ProviderRouterTransitions>, viewModel: ProviderRegisterViewModel) {
        self.router = router
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: ProviderRegisterViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismissKeyboard()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        // FIXME
        title = "Registro"
        disableTitle()
        
        bankTypeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bankTypeFieldTapped)))
        cityView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cityFieldTapped)))
        aboutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(aboutViewTapped)))
        
        originalInset = scrollView.contentInset
        
        enableKeyboardDismiss()
        disableTitle()
        setupKeyboardListeners()
        addIconInNavigationBar()
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
        
        viewModel.status.listen { [weak self] status in
            switch status {
            case .error(let error):
                self?.showError(message: error)
                
            case .registerDone:
                self?.router.transition(to: .uploadPhoto)
                
            default:
                return
            }
        }
    }
    
    private func validateForm() {
        // FIXME: Messages
        if documentTextField.safeText.isEmpty || documentTextField.safeText.count < 4 {
            showWarning(message: "Debes ingresar un documento válio.")
            
            return
        }
        
        if bankNumberTextField.safeText.isEmpty || bankNumberTextField.safeText.count < 4 {
            showWarning(message: "Debes ingresar un número bancario válio.")
            
            return
        }
        
        if bankNameTextField.safeText.isEmpty || bankNameTextField.safeText.count < 4 {
            showWarning(message: "Debes ingresar un nombre de banco.")
            
            return
        }
        
        if bankTypeTextField.safeText.isEmpty {
            showWarning(message: "Debes ingresar un tipo de banco.")
            
            return
        }
        
        if aboutTextView.safeText.isEmpty || aboutTextView.safeText.count < 3 {
            showWarning(message: "Es muy importante para tus futuros clientes saber algo de ti, por favor completa el campo.")
            
            return
        }
        
        submitForm()
    }
    
    private func submitForm() {
        let request = ProviderRequest(nickName: "",
                                      photoUrl: "",
                                      description: aboutTextView.safeText.trimmingCharacters(in: .whitespacesAndNewlines),
                                      document: documentTextField.safeText,
                                      bankAccountNumber: bankNumberTextField.safeText,
                                      bankAccountType: bankTypeTextField.safeText,
                                      bankName: bankNameTextField.safeText,
                                      cityId: viewModel.citySelectedId ?? 1)
        
        viewModel.postProviderRegister(request: request)
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
    
    @objc func aboutViewTapped() {
        let textViewModel = viewModel.getCompleteTextViewModel(savedValue: aboutTextView.text)
        
        router.transition(to: .completeText(viewModel: textViewModel, delegate: self))
    }
    
    @objc func cityFieldTapped() {
        router.transition(to: .listSelector(viewModel: viewModel.getCityListSelectorViewModel(), delegate: self))
    }
    
    @objc private func bankTypeFieldTapped() {
        router.transition(to: .listSelector(viewModel: viewModel.getListSelectorViewModel(), delegate: self))
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        scrollView.contentInset = UIEdgeInsets(top: originalInset.top,
                                               left: originalInset.left,
                                               bottom: originalInset.bottom + (keyboardSize?.height ?? 0),
                                               right: originalInset.right)
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentInset = originalInset
        animateLayout()
    }
}

// MARK: - ListSelectorViewControllerDelegate
extension ProviderRegisterViewController: ListSelectorViewControllerDelegate {
    func optionSelectedAt(index: Int, option: ListItemProtocol, uniqueIdentifier: String?) {
        switch uniqueIdentifier {
        case ProviderRegisterIdentifiers.city.rawValue:
            viewModel.citySelectedId = option.identifier as? Int
            cityTextField.text = option.value
            
        case ProviderRegisterIdentifiers.bankType.rawValue:
            bankTypeTextField.text = option.value
            
        default:
            return
        }
    }
}

// MARK: - CompleteTextViewDelegate
extension ProviderRegisterViewController: CompleteTextViewDelegate {
    func continueButtonTapped(viewModel: CompleteTextViewModel) {
        aboutTextView.text = viewModel.value
    }
}
