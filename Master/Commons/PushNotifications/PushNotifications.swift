//
//  PushNotifications.swift
//  Master
//
//  Created by Carlos Mejía on 9/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation
import EasyBinding

class PushNotifications {
    static let shared = PushNotifications()
    
    let hasPendingNotification = Var(false)
    
    private(set) var pendingNotification: PushNotification? {
        didSet {
            hasPendingNotification.value = pendingNotification != nil
        }
    }
    
    private init() {}
    
    func handle(userInfo: [AnyHashable: Any]) {
        guard
            let title = userInfo["title"] as? String,
            let body = userInfo["body"] as? String,
            let actionType = userInfo["actionType"] as? String,
            let convertedType = PushNotificationType(rawValue: actionType),
            let actionId = userInfo["actionId"] as? String else {
                return
        }
        
        pendingNotification = PushNotification(title: title, message: body, type: convertedType, actionId: actionId)
    }
    
    func notificationResolved() {
        pendingNotification = nil
    }
}
