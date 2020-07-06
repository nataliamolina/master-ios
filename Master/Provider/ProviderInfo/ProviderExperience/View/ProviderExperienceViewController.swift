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
    @IBOutlet private weak var sinceTextField: UITextField!
    @IBOutlet private weak var toTextField: UITextField!
    @IBOutlet private weak var positionTextField: UITextField!
    @IBOutlet private weak var placeTextField: UITextField!
    @IBOutlet private weak var countryTextField: UITextField!
    @IBOutlet private weak var cityTextField: UITextField!
    @IBOutlet private weak var isNowButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: - UI Actions
    @IBAction private func isNowAction() {
        viewModel?.info.isCurrent.toggle()
        nowValidate()
    }
    
    @IBAction private func saveAction() {
        saveInfo()
    }
    
    // MARK: - Properties
    private let datePicker = UIDatePicker()
    private let datePicker2 = UIDatePicker()
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
    
    private func showDatePicker() {
        datePicker.datePickerMode = .date
        datePicker2.datePickerMode = .date
        
        datePicker.maximumDate = Date()
        datePicker2.maximumDate = Date()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "ok", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        
        sinceTextField.inputAccessoryView = toolbar
        sinceTextField.inputView = datePicker
        
        toTextField.inputAccessoryView = toolbar
        toTextField.inputView = datePicker2
        
    }
    
    @objc private func donedatePicker() {
        validateTetField()
        setDatestring()
        view.endEditing(true)
    }
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
    
    private func setDatestring() {
        viewModel?.info.startDate = datePicker.date.toString()
        sinceTextField.text = viewModel?.info.startDateShow
        checktodate()
        
        viewModel?.info.endDate = datePicker2.date.toString()
        toTextField.text = viewModel?.info.endDateShow
    }
    
    private func checktodate() {
        datePicker2.minimumDate = datePicker.date
        if datePicker2.date < datePicker.date {
            datePicker2.date = datePicker.date
        }
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
        sinceTextField.delegate = self
        toTextField.delegate = self
        
        enableKeyboardDismiss()
        showDatePicker()
        setupBindings()
        setupWith()
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
                
            default:
                return
            }
        }
    }
    
    private func setupWith() {
        viewModel?.info.dataType = .experience
        sinceTextField.text = viewModel?.info.startDateShow
        toTextField.text = viewModel?.info.endDateShow
        positionTextField.text = viewModel?.info.position
        placeTextField.text = viewModel?.info.location
        countryTextField.text = viewModel?.info.country
        datePicker.date = viewModel?.info.startD ?? Date()
        datePicker2.date = viewModel?.info.endD ?? Date()
        nowValidate()
    }
    
    private func nowValidate() {
        validateTetField()
        let image = viewModel?.info.isCurrent ?? false ? UIImage(named: "circleFill") : UIImage(named: "circle")
        isNowButton.setImage(image, for: .normal)
        
        toTextField.text = viewModel?.info.isCurrent ?? false ? nil : viewModel?.info.endDateShow
        toTextField.isEnabled = !(viewModel?.info.isCurrent ?? false)
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
            let startDate = sinceTextField.text, !startDate.isEmpty,
            (toTextField.text != nil || viewModel?.info.isCurrent ?? false) else {
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
