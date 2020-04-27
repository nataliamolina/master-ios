//
//  CheckoutRadioCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 26/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol CheckoutRadioCellDataSource {
    var options: [RadioOption] { get set }
}

struct CheckoutRadioCellViewModel: CheckoutRadioCellDataSource, CellViewModelProtocol {
    var options: [RadioOption]
    let identifier: String = CheckoutRadioCell.cellIdentifier
}
