//
//  CheckoutHeaderCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 24/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol CheckoutHeaderCellDataSource {
    var title: String { get }
    var value: String { get }
}

struct CheckoutHeaderCellViewModel: CheckoutHeaderCellDataSource, CellViewModelProtocol {
    let title: String
    let value: String
    let identifier: String = CheckoutHeaderCell.cellIdentifier
}
