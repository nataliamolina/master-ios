//
//  String+Lang.swift
//  Master
//
//  Created by Carlos Mejía on 7/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

extension String {
    struct Lang {
        static let generalError = "general.error".localized
    }
    
    struct FormatDate {
        static let universalFormat = "yyyy-MM-dd'T00:00:00'"
        static let shortFormat = "dd/MMM/yyyy"
    }
}
