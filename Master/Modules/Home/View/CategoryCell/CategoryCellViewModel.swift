//
//  CategoryCellViewModel.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import Foundation

struct CategoryCellViewModel: CategoryCellDataSource, CellViewModelProtocol {
    var imageUrl: String
    var identifier: String = CategoryCell.cellIdentifier
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
}
