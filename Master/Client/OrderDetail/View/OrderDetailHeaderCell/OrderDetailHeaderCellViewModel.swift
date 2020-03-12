//
//  OrderDetailHeaderCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol OrderDetailHeaderCellDataSource {
    var orderId: Int { get }
    var status: OrderStateType { get }
    var providerName: String { get }
    var orderDate: String { get }
    var showMainButton: Bool { get }
}

struct OrderDetailHeaderCellViewModel: OrderDetailHeaderCellDataSource, CellViewModelProtocol {
    let orderId: Int
    let status: OrderStateType
    let providerName: String
    let orderDate: String
    let identifier: String = OrderDetailHeaderCell.cellIdentifier
    var showMainButton: Bool
}
