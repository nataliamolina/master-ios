//
//  ChatTableViewCellViewModel.swift
//  Master
//
//  Created by Maria Paula on 2/05/21.
//  Copyright © 2021 Master. All rights reserved.
//

import Foundation
import UIKit

struct ChatTableViewCellViewModel: CellViewModelProtocol {
    let identifier: String = ChatTableViewCell.cellIdentifier
    let messageId: String
    let authorId: String
    let chatMessage: String
    let createdAt: String
    var alignText: NSTextAlignment
}
