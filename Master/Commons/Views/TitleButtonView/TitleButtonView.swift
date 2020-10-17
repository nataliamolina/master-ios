//
//  TitleButtonView.swift
//  Master
//
//  Created by Maria Paula Gomez Prieto on 16/10/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import UIKit

class TitleButtonView: UIView {
    // MARK: - UI References
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleButton: MButton!
    @IBOutlet private weak var itemsCountView: UIView!
    @IBOutlet private weak var itemsCountLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setButton(title: String, style: MButtonType, items: Int = 0) {
        titleButton.style = style
        titleButton.title = title
        itemsCountView.isHidden = items <= 0
        itemsCountLabel.text = "\(items)"
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("TitleButtonView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
