//
//  MenuTitleCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 25/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct MenuTitleCellViewModel: MenuTitleCellDataSource, CellViewModelProtocol {
    let title: MenuTitle
    let isFirstItem: Bool
    let identifier: String = MenuTitleCell.cellIdentifier
}
