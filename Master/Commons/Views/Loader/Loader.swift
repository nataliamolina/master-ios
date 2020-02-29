//
//  Loader.swift
//  Master
//
//  Created by Carlos Mejía on 29/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class Loader {
    static var loaderReference: LoaderViewController?
    
    static func show(in viewController: UIViewController) {
        
        DispatchQueue.main.async {
            let loaderViewController = LoaderViewController()
            loaderViewController.modalPresentationStyle = .overCurrentContext
            
            loaderReference = loaderViewController
            
            viewController.present(loaderViewController, animated: false, completion: nil)
        }
    }
    
    static func dismiss() {
        DispatchQueue.main.async {
            loaderReference?.dismissAnimated()
            loaderReference = nil
        }
    }
}
