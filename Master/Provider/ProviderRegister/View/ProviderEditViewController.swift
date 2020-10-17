//
//  ProviderEditViewController.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/22/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol ProviderEditViewControllerDelegate: class {
    func infoEdited(provider: ProviderProfile?)
}

class ProviderEditViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var bankNumberTextField: MTextField!
    @IBOutlet private weak var bankNameTextField: MTextField!
    @IBOutlet private weak var bankTypeTextField: MTextField!
    @IBOutlet private weak var bankTypeView: UIView!
    @IBOutlet private weak var aboutTextView: MTextField!
    @IBOutlet private weak var aboutView: UIView!
    @IBOutlet private weak var nameTextField: MTextField!
    @IBOutlet private weak var lastNameTextField: MTextField!
    
    @IBOutlet private weak var cityTextField: MTextField!
    @IBOutlet private weak var cityView: UIView!
    
    // MARK: - UI Actions
    @IBAction private func editButtonAction() {
        validateForm()
    }
    
    // MARK: - Properties
    private let viewModel: ProviderEditViewModel
    private let router: RouterBase<ProviderRouterTransitions>
    private weak var delegate: ProviderEditViewControllerDelegate?
    
    // MARK: - Life Cycle
    init(router: RouterBase<ProviderRouterTransitions>, viewModel: ProviderEditViewModel,
         delegate: ProviderEditViewControllerDelegate?) {
        self.router = router
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: String(describing: ProviderEditViewController.self), bundle: nil)
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
        disableTitle()
        
        bankTypeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bankTypeFieldTapped)))
        cityView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cityFieldTapped)))
        aboutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(aboutViewTapped)))
        
        enableKeyboardDismiss()
        disableTitle()
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
                
            case .editDone:
                self?.delegate?.infoEdited(provider: self?.viewModel.getProvider())
                self?.navigationController?.popViewController(animated: true)
                
            default:
                return
            }
        }
     
        viewModel.about.bindTo(aboutTextView, to: .text)
        viewModel.city.bindTo(cityTextField, to: .text)
        viewModel.banck.bindTo(bankNameTextField, to: .text)
        viewModel.banckNumber.bindTo(bankNumberTextField, to: .text)
        viewModel.banckType.bindTo(bankTypeTextField, to: .text)
        viewModel.name.bindTo(nameTextField, to: .text)
        viewModel.lastName.bindTo(lastNameTextField, to: .text)
        viewModel.setValues()
    }
    
    private func validateForm() {
        if  !bankNumberTextField.safeText.isEmpty && bankNumberTextField.safeText.count < 4 {
            showWarning(message: "Debes ingresar un número bancario válio.")
            
            return
        }
        
        if  !bankNameTextField.safeText.isEmpty && bankNameTextField.safeText.count < 4 {
            showWarning(message: "Debes ingresar un nombre de banco.")
            
            return
        }
        
        if aboutTextView.safeText.isEmpty || aboutTextView.safeText.count < 3 {
            showWarning(message: "Es muy importante para tus futuros clientes saber algo de ti, por favor completa el campo.")
            
            return
        }
        
        submitForm()
    }
    
    private func submitForm() {
        let request = ProviderEditRequest(photoUrl: viewModel.getPhotoUrl(),
                                      description: aboutTextView.safeText.trimmingCharacters(in: .whitespacesAndNewlines),
                                      document: "",
                                      bankAccountNumber: bankNumberTextField.safeText,
                                      bankAccountType: bankTypeTextField.safeText,
                                      bankName: bankNameTextField.safeText,
                                      cityId: viewModel.citySelectedId ?? 1,
                                      firstName: nameTextField.safeText,
                                      lastName: lastNameTextField.safeText)
        
        viewModel.putProviderEdit(request: request)
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
}

// MARK: - ListSelectorViewControllerDelegate
extension ProviderEditViewController: ListSelectorViewControllerDelegate {
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
extension ProviderEditViewController: CompleteTextViewDelegate {
    func continueButtonTapped(viewModel: CompleteTextViewModel) {
        aboutTextView.text = viewModel.value
    }
}
