//
//  CommentCell.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell, ConfigurableCellProtocol {
    // MARK: - UI References
    @IBOutlet private weak var authorImageView: MImageView!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var authorMessageLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var bottomView: UIView!

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupUI()
    }
    
    // MARK: - Public Methods
    func setupWith(viewModel: Any?, indexPath: IndexPath?, delegate: Any?) {
        guard let viewModel = viewModel as? CommentCellDataSource else {
            return
        }
        
        authorImageView.kf.setImage(with: URL(string: viewModel.authorImageUrl), placeholder: UIImage.avatar)
        authorNameLabel.text = viewModel.authorNames
        authorMessageLabel.text = viewModel.authorMessage
        scoreLabel.text = viewModel.authorScore.asString
        
        bottomView.isHidden = viewModel.isLastItem
        
        setupEmptyBadgeIfRequired(viewModel: viewModel)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        authorImageView.kf.cancelDownloadTask()
        authorImageView.image = nil
        
        authorNameLabel.text = nil
        authorMessageLabel.text = nil
        scoreLabel.text = nil
        
        authorImageView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func setupEmptyBadgeIfRequired(viewModel: CommentCellDataSource) {
        guard viewModel.authorImageUrl.isEmpty else {
            return
        }
        
        authorImageView.image = nil
        
        let letterLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        letterLabel.text = String(viewModel.authorNames.first ?? Character(""))
        letterLabel.font = UIFont.boldSystemFont(ofSize: 26)
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        letterLabel.textColor = .white
        
        authorImageView.backgroundColor = UIColor.Master.green
        authorImageView.addSubview(letterLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: letterLabel,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: authorImageView,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: letterLabel,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: authorImageView,
                               attribute: .centerY,
                               multiplier: 1,
                               constant: 0)
        ])
    }
}
