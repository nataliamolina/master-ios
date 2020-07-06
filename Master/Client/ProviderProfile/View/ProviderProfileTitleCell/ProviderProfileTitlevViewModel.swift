//
//  ProviderProfileTitleviewModel.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 7/2/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct ProviderProfileTitleViewModel: CellViewModelProtocol {
    var identifier: String = ProviderProfileTitleCell.cellIdentifier
    let title: String
    let showButton: Bool
    let providerInfoType: ProviderInfoType
}
