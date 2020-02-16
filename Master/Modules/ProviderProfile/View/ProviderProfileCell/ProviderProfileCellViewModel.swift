//
//  ProviderProfileCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ProviderProfileCellDataSource {
    var photoUrl: String { get }
    var names: String { get }
    var description: String { get }
}

struct ProviderProfileCellViewModel: ProviderProfileCellDataSource, CellViewModelProtocol {
    let identifier: String = ProviderProfileCell.cellIdentifier
    let photoUrl: String
    let names: String
    let description: String
}
