//
//  RadioView.swift
//  Master
//
//  Created by Carlos Mejía on 26/04/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import UIKit

class RadioView: UIView {
    // MARK: - UI References
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var radioContainer: UIView!
    
    // MARK: - Properties
    private var index = 0
    private var isSelected: Bool = false
    var onTappedBlock: ((_ index: Int) -> Void)?
    
    // MARK: - Public Methods
    func setupWith(name: String, isSelected: Bool, index: Int) {
        self.index = index
        self.isSelected = isSelected

        titleLabel.text = name
        
        setupView()
        setupRecognizer()
        setupRadio()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        radioContainer.layer.borderWidth = 2
        radioContainer.layer.borderColor = UIColor.Master.green.cgColor
    }
    
    private func setupRecognizer() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    private func setupRadio() {
        if isSelected {
            let size: CGFloat = radioContainer.frame.width - 10
            let circleView = UIView(frame: CGRect(x: 5,
                                                  y: 5,
                                                  width: size,
                                                  height: size))
            
            circleView.layer.cornerRadius = size / 2
            circleView.backgroundColor = UIColor.Master.green
            
            radioContainer.addSubview(circleView)
        } else {
            radioContainer.subviews.forEach { $0.removeFromSuperview() }
        }
    }
    
    @objc private func viewTapped() {
        isSelected.toggle()
        
        onTappedBlock?(index)
        setupRadio()
    }
}
