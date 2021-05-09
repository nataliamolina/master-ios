//
//  PushNotificationService.swift
//  Master
//
//  Created by mac-devsavant on 5/05/21.
//  Copyright © 2021 Master. All rights reserved.
//

import Foundation

protocol PushNotificationServiceProtocol {
    func send(to token: String, title: String, message: String, actionId: String, actionType: PushNotificationType)
}

class PushNotificationService: PushNotificationServiceProtocol {
    
    // MARK: - Public Methods
    func send(to token: String, title: String, message: String, actionId: String, actionType: PushNotificationType) {
        sendPushNotification(to: token,
                             pushData: PushNotification(title: title,
                                                        message: message,
                                                        actionType: actionType,
                                                        actionId: actionId))
    }
    
    // MARK: - Private Methods
    private func sendPushNotification(to token: String, pushData: PushNotification) {
        guard let endpoint = NSURL(string: Endpoint.firebasePush()) else {  return  }
        
        guard let requestData = PushRequest(to: token, data: pushData).data else { return }
        
        let request = NSMutableURLRequest(url: endpoint as URL)
        request.httpMethod = "POST"
        request.httpBody = requestData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(Endpoint.getFirebaseApiKey())", forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest) { ( _, _, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
