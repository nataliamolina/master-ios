//
//  ProviderOrderCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 30/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ProviderOrderCellDataSource {
    var id: String { get }
    var userName: String { get }
    var orderCategory: String { get }
    var orderState: OrderStateType { get }
    var isLastItem: Bool { get }
}

struct ProviderOrderCellViewModel: ProviderOrderCellDataSource, CellViewModelProtocol {
    let id: String
    let userName: String
    let orderCategory: String
    let orderState: OrderStateType
    let isLastItem: Bool
    let identifier: String = ProviderOrderCell.cellIdentifier
}
