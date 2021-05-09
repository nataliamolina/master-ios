//
//  UITableView+Extensions.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit

extension UITableView {
    func registerNib(_ type: UITableViewCell.Type) {
        register(UINib(nibName: String(describing: type), bundle: nil),
                 forCellReuseIdentifier: String(describing: type))
    }
    
    func getWith(cellViewModel: CellViewModelProtocol?,
                 indexPath: IndexPath,
                 delegate: Any?) -> UITableViewCell {
        
        let identifier = cellViewModel?.identifier ?? "😭 This is a crash, i'm sorry."
        
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        (cell as? ConfigurableCellProtocol)?.setupWith(viewModel: cellViewModel,
                                                       indexPath: indexPath,
                                                       delegate: delegate)
        
        return cell
    }
    
    func scrollToBottomRow() {
        DispatchQueue.main.async {
            guard self.numberOfSections > 0 else { return }
            
            // Make an attempt to use the bottom-most section with at least one row
            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)
            
            // Ensure the index path is valid, otherwise use the section above (sections can
            // contain 0 rows which leads to an invalid index path)
            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)
                
                // If we're down to the last section, attempt to use the first row
                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }
            
            // In the case that [0, 0] is valid (perhaps no data source?), ensure we don't encounter an
            // exception here
            guard self.indexPathIsValid(indexPath) else { return }
            
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
    }
}
