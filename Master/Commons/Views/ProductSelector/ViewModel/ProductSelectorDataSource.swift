//
//  ProductSelectorDataSource.swift
//  Master
//
//  Created by Carlos Mejía on 21/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ProductSelectorDataSource {
    func getImageUrl() -> String
    func getName() -> String
    func getDescription() -> String
    func getPrice() -> Double
    func getFormattedPrice() -> String
    func getIdentifier() -> String
    func getTotalCount() -> Int
    func getTotalPrice() -> Double
}
