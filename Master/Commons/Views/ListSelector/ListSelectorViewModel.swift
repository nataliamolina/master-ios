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
    
    /// Used when the List selector is called multiple times in the same screen for different fields.
    let identifier: String?
    
    init(title: String?,
         desc: String?,
         dataSource: [ListItemProtocol],
         identifier: String? = nil) {
        
        self.title = title
        self.desc = desc
        self.dataSource = dataSource
        self.identifier = identifier
    }
}
