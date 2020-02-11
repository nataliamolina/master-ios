//
//  Array+Extensions.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import Foundation

extension Array {
    func safeContains(_ index: Int) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}
