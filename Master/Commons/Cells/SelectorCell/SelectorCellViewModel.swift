//
//  SelectorCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct SelectorCellButton {
    let style: MButtonType
    let title: String
}

protocol SelectorCellDataSource {
    var buttons: [SelectorCellButton] { get }
}

struct SelectorCellViewModel: SelectorCellDataSource, CellViewModelProtocol {
    let buttons: [SelectorCellButton]
    let identifier: String = SelectorCell.cellIdentifier
}
