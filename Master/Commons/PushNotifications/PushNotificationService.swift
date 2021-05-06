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
                                                        type: actionType,
                                                        actionId: actionId))
    }
    
    // MARK: - Private Methods
    private func sendPushNotification(to token: String, pushData: PushNotification) {
        let endpoint: URL = NSURL(fileURLWithPath: Endpoint.firebasePush()) as URL
        
        guard let requestData = PushRequest(to: token, data: pushData).data else { return }
        
        let request = NSMutableURLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.httpBody = requestData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=" + Endpoint.getFirebaseApiKey(), forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            
            if let error = error {
                print("Push notification failed: " + error.localizedDescription)
            }
            
        }.resume()
    }
}
