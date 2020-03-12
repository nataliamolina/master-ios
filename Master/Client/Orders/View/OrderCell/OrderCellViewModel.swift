//
//  OrderCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 29/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol OrderCellDataSource {
    var id: String { get }
    var providerName: String { get }
    var providerImageUrl: String { get }
    var orderTotal: Double { get }
    var orderCategory: String { get }
    var orderState: OrderStateType { get }
    var isLastItem: Bool { get }
}

struct OrderCellViewModel: OrderCellDataSource, CellViewModelProtocol {
    let id: String
    let providerName: String
    let providerImageUrl: String
    let orderTotal: Double
    let orderCategory: String
    let orderState: OrderStateType
    let isLastItem: Bool
    let identifier: String = OrderCell.cellIdentifier
}
