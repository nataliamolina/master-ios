//
//  CheckoutConstants.swift
//  Master
//
//  Created by Carlos Mejía on 24/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

struct CheckoutConstants {
    struct Lang {
        // FIXME: Heeeelp
        static let title = "checkout.title".localized
        static let address = "Dirección".localized
        static let city = "Ciudad".localized
        static let dateAndHour = "Fecha y Hora".localized
        static let notes = "Notas".localized
        static let products = "Productos".localized
        static let reserve = "Reservar Master".localized
        static let bogota = "general.bogota".localized
        
        static func cartTotal(_ total: Double) -> String {
            let plural = "s"
            
            return total.asInt.asString + "checkout.fields.product\(total > 1 ? plural : "")".localized
        }
    }
}
