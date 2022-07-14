//
//  MMessage.swift
//  iChat_App
//
//  Created by Felix Titov on 7/14/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation
import FirebaseFirestore
import MessageKit

struct MMessage: Hashable, MessageType {
    
    let content: String
    let id: String?
    
    var sender: SenderType
    var sentDate: Date
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        .text(content)
    }
    
    var representation: [String: Any] {
        var rep: [String: Any] = ["content": content]
        rep["senderId"] = sender.senderId
        rep["senderUsername"] = sender.displayName
        rep["created"] = sentDate
        
        return rep
        
    }
    
    init?(document: QueryDocumentSnapshot) {
       let data = document.data()
        guard
            let sentDate = data["created"] as? Timestamp,
            let senderId = data["senderId"] as? String,
            let senderUsername = data["senderUsername"] as? String,
            let content = data["content"] as? String
        else { return nil }
        
        self.id = document.documentID
        self.sentDate = sentDate.dateValue()
        sender = Sender(senderId: senderId, displayName: senderUsername)
        self.content = content

    }
    
    init(user: MUser, content: String) {
        self.content = content
        sender = Sender(senderId: user.id, displayName: user.username)
        sentDate = Date()
        id = nil
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    
}
