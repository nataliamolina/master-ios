//
//  ProviderServiceCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ProviderServiceCellDataSource {
    var productImageUrl: String { get }
    var productName: String { get }
    var productDesc: String { get }
    var productPrice: Double { get }
    var productCount: Int { get }
}

class ProviderServiceCellViewModel: ProviderServiceCellDataSource, CellViewModelProtocol {
    let identifier: String = ProviderServiceCell.cellIdentifier
    let productImageUrl: String
    let productName: String
    let productDesc: String
    let productPrice: Double
    var productCount: Int
    
    init(productImageUrl: String,
         productName: String,
         productDesc: String,
         productPrice: Double,
         productCount: Int) {
        
        self.productImageUrl = productImageUrl
        self.productName = productName
        self.productDesc = productDesc
        self.productPrice = productPrice
        self.productCount = productCount
    }
}
