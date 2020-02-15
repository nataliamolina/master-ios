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
        
        let identifier = cellViewModel?.identifier ?? ""
        
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        (cell as? ConfigurableCellProtocol)?.setupWith(viewModel: cellViewModel,
                                                       indexPath: indexPath,
                                                       delegate: self)
        
        return cell
    }
}
