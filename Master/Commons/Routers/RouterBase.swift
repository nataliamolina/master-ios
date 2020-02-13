//
//  RouterBase.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class RouterBase<T> {
    var rootViewController: BaseViewController
    
    init(rootViewController: BaseViewController) {
        self.rootViewController = rootViewController
    }
    
    func transition(to transition: T) {}
}
