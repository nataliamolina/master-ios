//
//  CheckoutFieldCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 24/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

enum CheckoutFieldCellType {
    case address
    case city
    case dates
    case notes
    case cart
}

protocol CheckoutFieldCellDataSource {
    var title: String { get }
    var value: String { get }
    var image: UIImage? { get }
    var bottomLineVisible: Bool { get }
    var type: CheckoutFieldCellType { get }
}

class CheckoutFieldCellViewModel: CheckoutFieldCellDataSource, CellViewModelProtocol {
    let title: String
    var value: String
    let image: UIImage?
    let bottomLineVisible: Bool
    let identifier: String = CheckoutFieldCell.cellIdentifier
    let type: CheckoutFieldCellType
    
    init(title: String, value: String, image: UIImage?, bottomLineVisible: Bool = true, type: CheckoutFieldCellType) {
        self.title = title
        self.value = value
        self.image = image
        self.bottomLineVisible = bottomLineVisible
        self.type = type
    }
}
