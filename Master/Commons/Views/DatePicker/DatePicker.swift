//
//  DatePicker.swift
//  Master
//
//  Created by Carlos Mejía on 27/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class DatePicker {
    static func show(in viewController: UIViewController,
                     delegate: DatePickerViewDelegate?,
                     index: Int = 0,
                     minDate: Date? = nil,
                     maxDate: Date? = nil,
                     nowDate: Date? = nil) {
        
        let selectorViewController = DatePickerViewController()
        selectorViewController.delegate = delegate
        selectorViewController.minDate = minDate
        selectorViewController.maxDate = maxDate
        selectorViewController.nowDate = nowDate
        selectorViewController.modalPresentationStyle = .overCurrentContext
        selectorViewController.index = index
        
        viewController.present(selectorViewController, animated: false, completion: nil)
        
    }
    
    static func dismiss() {
        guard
            let topViewController = UIApplication.getTopViewController(),
            topViewController is DatePickerViewController else {
            
            return
        }
        
        topViewController.dismiss(animated: true, completion: nil)
    }
}
