//
//  CompleteTextViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 24/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

class CompleteTextViewModel {
    let keyboardType: UIKeyboardType
    let title: String
    let desc: String
    let placeholder: String
    let index: Int
    let savedValue: String?
    
    var value: String? {
        didSet {
            isValidForm.value = self.value?.isEmpty == false ? true : false
        }
    }
    
    let isValidForm: Var<Bool> = Var(false)
    
    static var empty: CompleteTextViewModel {
        return CompleteTextViewModel(title: "", desc: "", placeholder: "", index: 0)
    }
    
    init(title: String,
         desc: String,
         placeholder: String,
         index: Int,
         keyboardType: UIKeyboardType = .default,
         savedValue: String? = nil) {
        
        self.index = index
        self.title = title
        self.desc = desc
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.savedValue = savedValue
        
        if let savedValue = savedValue {
            value = savedValue
        }
    }
}
