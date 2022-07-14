//
//  MMessage.swift
//  iChat_App
//
//  Created by Felix Titov on 7/14/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation
import FirebaseFirestore

struct MMessage: Hashable {
    let content: String
    let senderId: String
    let senderUsername: String
    let id: String?
    var sentDate: Date
    
    var representation: [String: Any] {
        var rep: [String: Any] = ["content": content]
        rep["senderId"] = senderId
        rep["senderUsername"] = senderUsername
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
        self.senderId = senderId
        self.senderUsername = senderUsername
        self.content = content

    }
    
    init(user: MUser, content: String) {
        self.content = content
        senderId = user.id
        senderUsername = user.username
        sentDate = Date()
        id = nil
    }
    
}
