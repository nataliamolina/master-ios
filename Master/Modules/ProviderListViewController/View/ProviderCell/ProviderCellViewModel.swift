//
//  ProviderCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ProviderCellDataSource {
    var imageUrl: String { get }
    var names: String { get }
    var score: Double { get }
    var desc: String { get }
    var totalOrders: Double { get }
    var isLastItem: Bool { get }
}

struct ProviderCellViewModel: ProviderCellDataSource, CellViewModelProtocol {
    let identifier: String = ProviderCell.cellIdentifier
    let providerUserId: Int
    let providerId: Int
    let imageUrl: String
    let names: String
    let score: Double
    let desc: String
    let totalOrders: Double
    let isLastItem: Bool
}
