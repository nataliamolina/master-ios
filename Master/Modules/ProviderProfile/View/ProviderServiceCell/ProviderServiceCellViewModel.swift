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
    let productId: Int
    var productCount: Int
    
    var totalPrice: Double {
        return Double(productCount * Int(productPrice))
    }
    
    init(productImageUrl: String,
         productName: String,
         productDesc: String,
         productPrice: Double,
         productCount: Int,
         productId: Int) {
        
        self.productImageUrl = productImageUrl
        self.productName = productName
        self.productDesc = productDesc
        self.productPrice = productPrice
        self.productCount = productCount
        self.productId = productId
    }
}

// MARK: - ProductSelectorDataSource
extension ProviderServiceCellViewModel: ProductSelectorDataSource {
    func getTotalPrice() -> Double {
        return totalPrice
    }
    
    func getTotalCount() -> Int {
        return productCount
    }
    
    func getImageUrl() -> String {
        return productImageUrl
    }
    
    func getName() -> String {
        return productName
    }
    
    func getDescription() -> String {
        return productDesc
    }
    
    func getPrice() -> Double {
        return productPrice
    }
    
    func getFormattedPrice() -> String {
        return productPrice.toFormattedCurrency(withSymbol: true)
    }
    
    func getIdentifier() -> String {
        return productId.asString
    }
}
