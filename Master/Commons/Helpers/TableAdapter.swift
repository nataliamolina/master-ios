//
//  TableAdapter.swift
//  Master
//
//  Created by Carlos Mejía on 15/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

protocol TableAdapterDataSource: class {
    var tableDataSource: Any { get }
    var titlesForHeaders: [String] { get }
}

class TableAdapter: NSObject, UITableViewDataSource {
    private let cells: [UITableViewCell.Type]
    private let tableView: UITableView
    private weak var data: TableAdapterDataSource?
    
    init(tableView: UITableView,
        data: TableAdapterDataSource?,
         cells: [UITableViewCell.Type],
         separatorStyle: UITableViewCell.SeparatorStyle = .none) {
        
        self.tableView = tableView
        self.data = data
        self.cells = cells
        
        tableView.separatorStyle = separatorStyle
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        cells.forEach { tableView.registerNib($0) }
    }
    
    func setup() {
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Check for a matrix
        if let dataSource = data?.tableDataSource as? [[Any]] {
            return dataSource.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data?.titlesForHeaders.safeContains(section) ?? nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Check for an array
        if let dataSource = data?.tableDataSource as? [CellViewModelProtocol] {
            return dataSource.count
        }
        
        // Check for a matrix
        if let dataSource = data?.tableDataSource as? [[CellViewModelProtocol]] {
            return dataSource.safeContains(section)?.count ?? 0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellViewModel: CellViewModelProtocol?
        
        // Check for an array
        if let dataSource = data?.tableDataSource as? [CellViewModelProtocol] {
            cellViewModel = dataSource.safeContains(indexPath.row)
        }
        
        // Check for a matrix
        if let dataSource = data?.tableDataSource as? [[CellViewModelProtocol]] {
            cellViewModel = dataSource
                .safeContains(indexPath.section)?
                .safeContains(indexPath.row)
        }
        
        let identifier = cellViewModel?.identifier ?? "default"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        (cell as? ConfigurableCellProtocol)?.setupWith(viewModel: cellViewModel,
                                                       indexPath: indexPath,
                                                       delegate: self)
        
        return cell
    }
}
