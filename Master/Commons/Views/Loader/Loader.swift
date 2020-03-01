//
//  Loader.swift
//  Master
//
//  Created by Carlos Mejía on 29/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class Loader {
    static var loaderReference: LoaderView?
    
    static func show() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }

        DispatchQueue.main.async {
            let loaderView: LoaderView = .fromNib()
            loaderView.frame = UIScreen.main.bounds
            loaderView.showLoader()
            
            loaderReference = loaderView
            
            window.addSubview(loaderView)
        }
    }
    
    static func dismiss(onComplete: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            loaderReference?.dismissAnimated(onComplete: onComplete)
            loaderReference?.removeFromSuperview()
            loaderReference = nil
        }
    }
}
