//
//  Threads.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
func BackgroundThread(operation: @escaping () -> Void) {
    DispatchQueue.global(qos: .background).async {
        operation()
    }
}

func MainThread(operation: @escaping () -> Void) {
    DispatchQueue.main.async {
        operation()
    }
}
// swiftlint:enable identifier_name
