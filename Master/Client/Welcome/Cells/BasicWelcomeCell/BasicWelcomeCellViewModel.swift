//
//  BasicWelcomeCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 27/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct BasicWelcomeCellViewModel: BasicWelcomeCellDataSource, CellViewModelProtocol {
    let title: String
    let desc: String
    let animName: AnimationType
    let identifier: String = BasicWelcomeCell.cellIdentifier
}
