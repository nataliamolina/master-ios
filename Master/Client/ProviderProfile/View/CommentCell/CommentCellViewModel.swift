//
//  CommentCellViewModel.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

protocol CommentCellDataSource {
    var authorImageUrl: String { get }
    var authorNames: String { get }
    var authorMessage: String { get }
    var authorScore: Double { get }
    var isLastItem: Bool { get }
}

struct CommentCellViewModel: CommentCellDataSource, CellViewModelProtocol {
    let authorImageUrl: String
    let authorNames: String
    let authorMessage: String
    let authorScore: Double
    let identifier: String = CommentCell.cellIdentifier
    let isLastItem: Bool
}
