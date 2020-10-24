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
    
    private weak var delegate: SelectorCellDelegate?
    private var index: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setButton(index: Int, title: String, style: MButtonType, delegate: SelectorCellDelegate?, items: Int = 0) {
        titleButton.style = style
        titleButton.title = title
        itemsCountView.isHidden = items <= 0
        itemsCountLabel.text = "\(items)"
        self.index = index
        self.delegate = delegate
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("TitleButtonView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // MARK: - UI Actions
    @IBAction private func addServiceButtonAction() {
        delegate?.buttonTapped(at: index, title: titleButton.title ?? "", button: titleButton)
    }
    
}
