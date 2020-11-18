//
//  DatePickerViewController.swift
//  Master
//
//  Created by Carlos Mejía on 27/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol DatePickerViewDelegate: class {
    func dateSelected(_ date: Date, at index: Int)
}

class DatePickerViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var calendarView: UIView!
    @IBOutlet private weak var calendarViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - UI Actions
    @IBAction private func dismissButtonAction() {
        dismissView()
    }
    
    @IBAction private func continueButtonAction() {
        delegate?.dateSelected(datePicker.date, at: index)
        dismissView()
    }
    
    // MARK: - Properties
    weak var delegate: DatePickerViewDelegate?
    var minDate: Date?
    var maxDate: Date?
    var nowDate: Date?
    
    private lazy var hiddenContainerValue = -calendarView.frame.height
    private var originalColor: UIColor?
    private let animationDuration: TimeInterval = 0.3
    var index = 0

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showCalendar()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        originalColor = view.backgroundColor?.copy() as? UIColor
        
        view.backgroundColor = .clear
        
        calendarViewBottomConstraint.constant = hiddenContainerValue
        
        /*view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))*/
        
        if minDate == nil && maxDate == nil {
            setupDatePicker()
            return
        }
        
        if let date = minDate {
            setupMinDatePicker(minDate: date)
        }
        
        if let date = maxDate {
            setupMaxDatePicker(maxDate: date)
        }
        
        if let date = nowDate {
            datePicker.date = date
        }
    }
    
    private func setupDatePicker() {
        var calendarComponents = DateComponents()
        calendarComponents.day = 1
        
        if let tomorrowDate = Calendar.current.date(byAdding: calendarComponents, to: Date()),
            let date = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: tomorrowDate) {
            
            datePicker.minimumDate = date
        }
        
        calendarComponents.day = 30
        
        if let maxDate = Calendar.current.date(byAdding: calendarComponents, to: Date()),
            let date = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: maxDate) {
            
            datePicker.maximumDate = date
        }
    }
    
    func setupMinDatePicker(minDate: Date) {
        datePicker.minimumDate = minDate
    }
    
    func setupMaxDatePicker(maxDate: Date) {
        datePicker.maximumDate = maxDate
    }
    
    @objc private func dismissView() {
        calendarViewBottomConstraint.constant = hiddenContainerValue
        
        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            self?.view.backgroundColor = .clear
        }, completion: { [weak self] _ in
            self?.dismiss(animated: false, completion: nil)
        })
    }
    
    private func showCalendar() {
        calendarViewBottomConstraint.constant = 0
        
        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.view.backgroundColor = self?.originalColor
        }
    }
}
