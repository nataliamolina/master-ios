//
//  Loader.swift
//  Master
//
//  Created by Carlos Mejía on 29/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class Loader {
    
    static func show() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        DispatchQueue.main.async {
            let loaderView: LoaderView = .fromNib()
            loaderView.frame = UIScreen.main.bounds
            loaderView.showLoader()
            
            window.addSubview(loaderView)
        }
    }
    
    static func dismiss(onComplete: (() -> Void)? = nil) {
        guard let loaderReference = UIApplication.shared.keyWindow?.subviews.filter({
            $0 is LoaderView
        }).first as? LoaderView else {
            return
        }
        
        DispatchQueue.main.async {
            loaderReference.dismissAnimated {
                loaderReference.removeFromSuperview()
                onComplete?()
            }
        }
    }
}
