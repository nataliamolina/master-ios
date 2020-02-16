//
//  MImageView.swift
//  Master
//
//  Created by Carlos Mejía on 16/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

class MImageView: UIImageView {
    // MARK: - Life Cycle
      override func awakeFromNib() {
          super.awakeFromNib()
          
          setupUI()
      }
      
      override init(frame: CGRect) {
          super.init(frame: frame)
          
          setupUI()
      }
      
      required init?(coder: NSCoder) {
          super.init(coder: coder)
          
          setupUI()
      }
    
    // MARK: - Private Methods
    private func setupUI() {
        layer.cornerRadius = frame.width / 2
        layer.borderColor = UIColor.Master.green.cgColor
        layer.borderWidth = 2
        
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}
