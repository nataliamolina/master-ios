//
//  CheckoutProviderCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 24/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol CheckoutProviderCellDataSource {
    var name: String { get }
    var description: String { get }
    var photoUrl: String { get }
}

struct CheckoutProviderCellViewModel: CheckoutProviderCellDataSource, CellViewModelProtocol {
    let name: String
    let description: String
    let photoUrl: String
    let identifier: String = CheckoutProviderCell.cellIdentifier
}
