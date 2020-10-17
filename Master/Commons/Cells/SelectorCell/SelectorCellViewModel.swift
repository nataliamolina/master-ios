//
//  SelectorCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct SelectorCellButton {
    var style: MButtonType
    let title: String
    let items: Int
}

protocol SelectorCellDataSource {
    var buttons: [SelectorCellButton] { get }
}

struct SelectorCellViewModel: SelectorCellDataSource, CellViewModelProtocol {
    var buttons: [SelectorCellButton]
    let identifier: String = SelectorCell.cellIdentifier
}
