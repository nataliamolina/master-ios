//
//  ListSelectorViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol ListItemProtocol {
    var value: String { get }
    var identifier: Any? { get }
}

struct ListSelectorViewModel {
    let title: String?
    let desc: String?
    let dataSource: [ListItemProtocol]
}
