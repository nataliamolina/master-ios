//
//  ProductSelector.swift
//  Master
//
//  Created by Carlos Mejía on 21/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class ProductSelector {
    static func show(in viewController: UIViewController,
                     viewModel: ProductSelectorDataSource,
                     delegate: ProductSelectorDelegate?) {
        
        let selectorViewController = ProductSelectorViewController(viewModel: viewModel, delegate: delegate)
        
        viewController.present(selectorViewController, animated: true, completion: nil)
        
    }
    
    static func dismiss() {
        guard
            let topViewController = UIApplication.getTopViewController(),
            topViewController is ProductSelectorViewController else {
            
            return
        }
        
        topViewController.dismiss(animated: true, completion: nil)
    }
}
