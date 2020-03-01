//
//  Styles.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit

typealias ButtonStyleConfig = (bg: UIColor, border: UIColor, text: UIColor)

struct Styles {
    static var buttonStyles: [MButtonType: ButtonStyleConfig] = [
        .whiteBorder: (.clear, .white, UIColor.Master.green),
        .greenBorder: (.clear, UIColor.Master.green, UIColor.Master.green),
        .white: (.white, .clear, UIColor.Master.green),
        .green: (UIColor.Master.green, .clear, .white),
        .onlyWhiteText: (.clear, .clear, .white),
        .redBorder: (.clear, UIColor.Master.red, UIColor.Master.red),
        .yellow: (UIColor.Master.yellow, .clear, .white)
    ]
}
