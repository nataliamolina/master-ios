//
//  XibView.swift
//  Master
//
//  Created by Carlos Mejía on 24/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit

open class XibView: UIView {
      
      open var view: UIView?
      open var xibName: String?
      open var bundleView: Bundle? {
          return nil
      }
      
      override public init(frame: CGRect) {
          super.init(frame: frame)
          setupXib()
      }
      
      required public init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          setupXib()
      }
      
      func setupXib() {
          guard view == nil, let mainView = loadViewFromNib() else { return }
          
          translatesAutoresizingMaskIntoConstraints = false
          mainView.translatesAutoresizingMaskIntoConstraints = false
          backgroundColor = .clear
          addSubview(mainView)
          addConstraintsToFit(view: mainView)
          
          view = mainView
      }
      
      open func loadViewFromNib() -> UIView? {
          let nib = UINib(nibName: className(), bundle: bundle())
          let view = nib.instantiate(withOwner: self, options: nil).compactMap { $0 as? UIView}.first
          return view
      }
      
      open func className() -> String {
          if let xibName = xibName {
              return xibName
          } else {
              return String(describing: type(of: self))
          }
      }
      
      open func bundle() -> Bundle {
          if let bundle = bundleView {
              return bundle
          } else {
              return Bundle(for: type(of: self))
          }
      }
      
      override open func removeFromSuperview() {
          view?.removeFromSuperview()
          super.removeFromSuperview()
      }
}
