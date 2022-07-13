//
//  MMessage.swift
//  iChat_App
//
//  Created by Felix Titov on 7/14/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

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
    
    init(user: MUser, content: String) {
        self.content = content
        senderId = user.id
        senderUsername = user.username
        sentDate = Date()
        id = nil
    }
    
}
