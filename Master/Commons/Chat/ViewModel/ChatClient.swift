//
//  ChatClient.swift
//  Master
//
//  Created by mac-devsavant on 2/05/21.
//  Copyright © 2021 Master. All rights reserved.
//

import Foundation
import Firebase

class ChatClient {
    // MARK: - Properties
    private(set) var messages = [ChatMessage]()
    private var decoder = JSONDecoder()
    private var observingChatId: String?
    
    private let chats = "chats"
    
    private var dataBase: DatabaseReference {
        return Database.database().reference()
    }
    
    private var chatListRef: DatabaseReference {
        return dataBase.child(chats)
    }
    
    weak var delegate: ChatClientDelegate?
    
    // MARK: - Life Cycle
    
    // MARK: - Public Methods
    
    /**
     Method to fetch all the items saved in db with the movie id provided.
     - parameter chatId: Id of the movie to find in DB.
     */
    func fetchAllMessages(chatId: String) {
        chatListRef.removeAllObservers()
        startListenerTo(chatId: chatId)
    }
    
    /**
     Method to send a message to the real time bd.
     - parameter text: String for message, this method WILL NOT validate the input.
     - parameter chatId: Id of the movie to find in DB.
     */
    func sendMessage(_ text: String, userId: String, chatId: String) {
        let date = Date()
        let id = (Int(date.timeIntervalSince1970)).asString
          
        let dbReference = chatListRef.child(chatId).child(id)
        let messageToSave = ChatMessage(messageId: id,
                                        authorId: userId,
                                        message: text,
                                        createdAt: date.asJson)
        
        dbReference.setValue(messageToSave.dictionary)
    }

    /**
     Method to observe all the messages in the provided movie.
     - parameter chatId: Id of the movie to find in DB.
     */
    func startListenerTo(chatId: String) {
        
        let dbReference = dataBase.child(chats).child(chatId)
        
        dbReference.observe(DataEventType.childAdded, with: { [weak self] (snapshot) in
            
            do {
                guard
                    let message = try snapshot.toCodable(ChatMessage.self, asArray: false),
                    self?.messages.filter({ $0.messageId == message.messageId }).isEmpty == true else {
                        return
                }
                
                self?.messages.append(message)
                self?.delegate?.newMessageArrived(result: .success(messages: [message], chatId: chatId))
                
            } catch let error {
                self?.delegate?.newMessageArrived(result: .error(error: error))
            }
        })
    }
    
    /**
     Method to reset all the messages stored from the real time bd.
     */
    func resetDataSource() {
        messages.removeAll()
    }
   
    func stopListeningUpdates() {
        dataBase.child(chats).removeAllObservers()
        
        guard let observingChatId = observingChatId else {
            return
        }
        
        dataBase.child(chats).child(observingChatId).removeAllObservers()
        self.observingChatId = nil
    }
}

extension DataSnapshot {
    func toCodable<T: Codable>(_ type: T.Type, asArray: Bool) throws -> T? {
        let decoder = JSONDecoder()
        
        guard
            let postDict = self.value as? [String: Any],
            !postDict.isEmpty  else {
                return nil
        }
        
        var data: Data?
        
        /*
         Double do catch just in order to debug propertly
         */
        
        do {
            if asArray {
                data = try JSONSerialization.data(withJSONObject: postDict.map { $0.value }, options: [])
            } else {
                data = try JSONSerialization.data(withJSONObject: postDict, options: [])
            }
        } catch let error {
            print(error)
            
            return nil
        }
        
        do {
            return try decoder.decode(T.self, from: data ?? Data())
        } catch let error {
            print(error)
            
            return nil
        }
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var data: Data? {
        return try? JSONSerialization.data(withJSONObject: self.dictionary ?? [:] , options: [.prettyPrinted])
    }
}
