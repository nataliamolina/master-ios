//
//  PushRequest.swift
//  Master
//
//  Created by mac-devsavant on 5/05/21.
//  Copyright © 2021 Master. All rights reserved.
//

import Foundation

struct PushRequest: Codable {
    let notification: PushRequestNotification
    let options = PushRequestOptions()
    let destination: String
    let data: PushNotification
    
    init(to token: String, data: PushNotification) {
        self.notification = PushRequestNotification(title: data.title, body: data.message)
        self.destination = token
        self.data = data
    }
    
    private enum CodingKeys: String, CodingKey {
        case notification
        case options
        case destination = "to"
        case data
    }
}

struct PushRequestNotification: Codable {
    let title: String
    let body: String
    let badge: Int = 1
    let sound: String = "default"
}

struct PushRequestOptions: Codable {
    let priority: String = "high"
    let apnsPriority: Int = 5
    let mutableContent: Bool = true
    let contentAvailable: Int = 1
    let apnsPushType: String = "alert"
}
