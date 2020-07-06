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
    
    // MARK: - UI Actions
    @IBAction private func isNowAction() {
        viewModel?.info.isCurrent.toggle()
        nowValidate()
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
        setDatestring(date: datePicker.date, date2: datePicker.date)
        view.endEditing(true)
    }
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
    
    private func setDatestring(date: Date?, date2: Date?) {
        let formatter = DateFormatter()
        formatter.dateFormat = formatdate
        
        if let dateSince = date {
            sinceTextField.text = formatter.string(from: dateSince)
        }
        
        if let dateTo = date2 {
            toTextField.text = formatter.string(from: dateTo)
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
        enableKeyboardDismiss()
        showDatePicker()
        setupWith()
    }
    
    private func setupWith() {
        sinceTextField.text = viewModel?.info.startDate
        toTextField.text = viewModel?.info.endDate
        positionTextField.text = viewModel?.info.position
        placeTextField.text = viewModel?.info.location
        countryTextField.text = viewModel?.info.country
        cityTextField.text = viewModel?.info.city
        nowValidate()
    }
    
    private func nowValidate() {
       let image = viewModel?.info.isCurrent ?? false ? UIImage(named: "circleFill") : UIImage(named: "circle")
        isNowButton.setImage(image, for: .normal)
    }
    
    private func saveInfo() {
        guard let position = positionTextField.text,
            let location = placeTextField.text,
            let country = countryTextField.text,
            let city = cityTextField.text,
            let startDate = sinceTextField.text,
            let endDate = toTextField.text else {
                return
        }
        viewModel?.info.position = position
        viewModel?.info.location = location
        viewModel?.info.country = country
        viewModel?.info.city = city
        viewModel?.info.startDate = startDate
        viewModel?.info.endDate = endDate
        
        viewModel?.saveInfo()
    }
}
