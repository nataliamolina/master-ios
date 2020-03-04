//
//  PaymentResponse.swift
//  Master
//
//  Created by Carlos Mejía on 3/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct PaymentResponse: Codable {
    let isPaymentDone: Bool
    let errorMessage: String
}
