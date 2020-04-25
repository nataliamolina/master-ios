//
//  MenuOptionCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 25/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct MenuOptionCellViewModel: MenuOptionCellDataSource, CellViewModelProtocol {
    let option: MenuOption
    let identifier: String = MenuOptionCell.cellIdentifier
}
