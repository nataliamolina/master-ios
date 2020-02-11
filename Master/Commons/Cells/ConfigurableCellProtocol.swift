//
//  ConfigurableCellProtocol.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import Foundation

protocol ConfigurableCellProtocol {
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?)
}
