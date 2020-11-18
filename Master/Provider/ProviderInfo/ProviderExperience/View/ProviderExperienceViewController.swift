//
//  ProviderExperienceViewController.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 6/30/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class ProviderExperienceViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var sinceLabel: UILabel!
    @IBOutlet private weak var toLabel: UILabel!
    @IBOutlet private weak var positionTextField: UITextField!
    @IBOutlet private weak var placeTextField: UITextField!
    @IBOutlet private weak var countryTextField: UITextField!
    @IBOutlet private weak var cityTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var radiostackView: UIStackView!
    
    // MARK: - UI Actions
    @IBAction private func saveAction() {
        saveInfo()
    }
    
    // MARK: - Properties
    private let viewModel: ProviderInfoViewModel?
    private weak var delegate: ProviderInfoEditDelegate?
    private let formatdate = "dd/MMM/yyyy"
    
    // MARK: - Life Cycle
    init(viewModel: ProviderInfoViewModel,
         delegate: ProviderInfoEditDelegate?) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: String(describing: ProviderExperienceViewController.self), bundle: nil)
    }
    
    private func setRadioButton() {
        let radioView: RadioView = .fromNib()
        radioView.setupWith(name: "providerExperience.now".localized, isSelected: viewModel?.info.isCurrent ?? false, index: 0)
        radioView.onTappedBlock = { [weak self] index in
            self?.viewModel?.info.isCurrent.toggle()
            self?.nowValidate()
        }
        radiostackView.addSubview(radioView)
        nowValidate()
    }
    
    private func setDatestring(index: DateInput, date: Date) {
            
        switch index {
        case .since:
            viewModel?.startDate = date
            viewModel?.info.startDate = date.toString()
            sinceLabel.text = viewModel?.info.startDateShow
                
        case .end:
            viewModel?.endDate = date
            viewModel?.info.endDate = date.toString()
            toLabel.text = viewModel?.info.endDateShow
        }
            
            validateTetField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder init not implemented.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismissKeyboard()
    }
    
    private func setupView() {
        saveButton.isEnabled = false
        saveButton.isEnabled = false
        positionTextField.delegate = self
        placeTextField.delegate = self
        countryTextField.delegate = self
        cityTextField.delegate = self
        
        enableKeyboardDismiss()
        setupBindings()
        setupWith()
        navigationItem.title = "providerInfo.experinces".localized
    }
    
    private func setupBindings() {
        viewModel?.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
        
        viewModel?.status.listen { [weak self] status in
            switch status {
            case .error(let error):
                self?.showError(message: error)
                
            case .postSuccessful(let info):
                self?.navigationController?.popViewControllerWithHandler { [weak self] in
                    self?.delegate?.serviceEdited(info: info)
                }
            case .putSuccessful(let info):
                self?.navigationController?.popViewControllerWithHandler { [weak self] in
                    self?.delegate?.serviceEdited(info: info)
                }
            case .deleteSuccessful(let info):
                self?.navigationController?.popViewControllerWithHandler { [weak self] in
                    self?.delegate?.serviceEdited(info: info)
                }
                
            default:
                return
            }
        }
    }
    
    private func setupWith() {
        viewModel?.info.dataType = .experience
        sinceLabel.text = viewModel?.info.startDateShow
        toLabel.text = viewModel?.info.endDateShow
        positionTextField.text = viewModel?.info.position
        placeTextField.text = viewModel?.info.location
        cityTextField.text = viewModel?.info.city
        countryTextField.text = viewModel?.info.country
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openDatePickerStart))
        sinceLabel.isUserInteractionEnabled = true
        sinceLabel.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(openDatePickerEnd))
        toLabel.isUserInteractionEnabled = true
        toLabel.addGestureRecognizer(tap2)
        
        setRadioButton()
    }
    
    @objc func openDatePickerStart() {
        DatePicker.show(in: self, delegate: self, index: DateInput.since.rawValue,
                        maxDate: viewModel?.endDate,
                        nowDate: viewModel?.startDate)
    }
    
    @objc func openDatePickerEnd() {
        DatePicker.show(in: self, delegate: self, index: DateInput.end.rawValue,
                        minDate: viewModel?.startDate,
                        maxDate: Date(),
                        nowDate: viewModel?.endDate)
    }
    
    private func nowValidate() {
        validateTetField()
        
        toLabel.text = viewModel?.info.isCurrent ?? false ? nil : viewModel?.info.endDateShow
        toLabel.isEnabled = !(viewModel?.info.isCurrent ?? false)
        toLabel.isUserInteractionEnabled = !(viewModel?.info.isCurrent ?? false)
    }
    
    private func saveInfo() {
        guard let position = positionTextField.text,
            let location = placeTextField.text,
            let country = countryTextField.text,
            let city = cityTextField.text else {
                return
        }
        viewModel?.info.position = position
        viewModel?.info.location = location
        viewModel?.info.country = country
        viewModel?.info.city = city
        
        viewModel?.saveInfo()
    }
    
    private func validateTetField() {
        guard let position = positionTextField.text, !position.isEmpty,
            let location = placeTextField.text, !location.isEmpty,
            let country = countryTextField.text, !country.isEmpty,
            let city = cityTextField.text, !city.isEmpty,
            let startDate = sinceLabel.text, !startDate.isEmpty,
            (toLabel.text != nil || viewModel?.info.isCurrent ?? false) else {
                return
        }
        saveButton.isEnabled = true
    }
}

extension ProviderExperienceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validateTetField()
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            dismissKeyboard()
        }
        return true
    }
}

// MARK: - DatePickerViewDelegate
extension ProviderExperienceViewController: DatePickerViewDelegate {
    func dateSelected(_ date: Date, at index: Int) {
        
        guard let dateType = DateInput(rawValue: index) else { return }
        setDatestring(index: dateType, date: date)
    }
}
