//
//  ChatMessage.swift
//  Master
//
//  Created by mac-devsavant on 2/05/21.
//  Copyright © 2021 Master. All rights reserved.
//

import Foundation

struct ChatMessage: Codable {
    let messageId: String
    let authorId: String
    var message: String
    let createdAt: String
    
    var date: (day: Int, month: Int, year: Int)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = dateFormatter.date(from: createdAt) else {
            return nil
        }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        return (day, month, year)
    }
    
    init(messageId: String,
         authorId: String,
         message: String,
         createdAt: String) {
        self.messageId = messageId
        self.authorId = authorId
        self.message = message
        self.createdAt = createdAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.messageId = try container.decode(String.self, forKey: .messageId)
        self.authorId = try container.decode(String.self, forKey: .authorId)
        self.message = try container.decode(String.self, forKey: .message)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
    }
}
