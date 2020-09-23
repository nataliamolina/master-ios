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
        static let title = "checkout.title".localized
        static let address = "Dirección".localized
        static let city = "Ciudad".localized
        static let conditions = "Condiciones".localized
        static let dateAndHour = "Fecha y Hora".localized
        static let notes = "Notas".localized
        static let excess = "Excedente".localized
        static let description = "Descripción excedente".localized
        static let products = "Productos".localized
        static let reserve = "Reservar Master".localized
        static let bogota = "general.bogota".localized
        static let ups = "general.ups".localized
        static let `continue` = "general.continue".localized
        static let cancel = "general.close".localized
        static let completeField = "Debes completar ".localized
        
        static func cartTotal(_ total: Double) -> String {
            let plural = "s"
            
            return total.asInt.asString + "checkout.fields.product\(total > 1 ? plural : "")".localized
        }
    }
}
