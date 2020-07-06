//
//  ProviderInfoCellViewModel.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 6/30/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ProviderInfoCellDataSource {
    var id: Int { get }
    var title: String { get }
    var subTitle: String { get }
    var startDate: String { get }
    var finishDate: String { get }
    var country: String { get }
    var city: String { get }
    var isProvider: Bool { get }
    var isCurrent: Bool { get }
    var providerInfoType: ProviderInfoType { get }
    var startDateShow: String { get }
    var endDateShow: String { get }
}
struct ProviderInfoCellViewModel: ProviderInfoCellDataSource, CellViewModelProtocol {
    let title: String
    let subTitle: String
    let startDate: String
    let finishDate: String
    let country: String
    var city: String
    let id: Int
    let isProvider: Bool
    let isCurrent: Bool
    let identifier: String = ProviderInfoCell.cellIdentifier
    let providerInfoType: ProviderInfoType
    
    var startD: Date? {
        return startDate.toDate(format: String.FormatDate.universalFormat)
    }
    
    var endD: Date? {
        return finishDate.toDate(format: String.FormatDate.universalFormat)
    }
    
    var startDateShow: String {
        return startD?.toString(format: String.FormatDate.shortFormat) ?? ""
    }
    
    var endDateShow: String {
        return endD?.toString(format: String.FormatDate.shortFormat) ?? ""
    }
}
