//
//  TitleCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 29/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol TitleCellDataSource {
    var title: String { get }
}

struct TitleCellViewModel: TitleCellDataSource, CellViewModelProtocol {
    let title: String
    let identifier: String = TitleCell.cellIdentifier
}
