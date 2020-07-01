//
//  ProviderInfoCellViewModel.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 6/30/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ProviderInfoCellDataSource {
    var id: String { get }
    var title: String { get }
    var subTitle: String { get }
    var date: String { get }
    var place: String { get }
    var isProvider: Bool { get }
}
struct ProviderInfoCellViewModel: ProviderInfoCellDataSource, CellViewModelProtocol {
    let title: String
    let subTitle: String
    let date: String
    let place: String
    let id: String
    let isProvider: Bool
    let identifier: String = ProviderInfoCell.cellIdentifier
}
