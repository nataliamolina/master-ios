//
//  ButtonCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 24/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ButtonCellDataSource {
    var style: MButtonType { get }
    var title: String { get }
    var value: Any? { get }
}

struct ButtonCellViewModel: ButtonCellDataSource, CellViewModelProtocol {
    let style: MButtonType
    let title: String
    let value: Any?
    let identifier: String = ButtonCell.cellIdentifier
}
