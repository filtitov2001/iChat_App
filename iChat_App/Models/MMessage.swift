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

struct ImageItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
}

struct MMessage: Hashable, MessageType {
    
    let content: String
    let id: String?
    
    var sender: SenderType
    var sentDate: Date
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        if let image = image {
            let mediaItem = ImageItem(url: nil, image: nil, placeholderImage: image, size: image.size)
            return .photo(mediaItem)
        } else {
            return .text(content)
        }
    }
    
    var representation: [String: Any] {
        var rep: [String: Any] = ["senderId": sender.senderId]
        rep["senderUsername"] = sender.displayName
        rep["created"] = sentDate
        
        if let url = downloadURL {
            rep["url"] = url.absoluteString
        } else {
            rep["content"] = content
        }
        
        return rep
        
    }
    
    var image: UIImage? = nil
    var downloadURL: URL? = nil
    
    init?(document: QueryDocumentSnapshot) {
       let data = document.data()
        guard
            let sentDate = data["created"] as? Timestamp,
            let senderId = data["senderId"] as? String,
            let senderUsername = data["senderUsername"] as? String
        //    let content = data["content"] as? String
        else { return nil }
        
        self.id = document.documentID
        self.sentDate = sentDate.dateValue()
        sender = Sender(senderId: senderId, displayName: senderUsername)
        
        if let content = data["content"] as? String {
            self.content = content
            downloadURL = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            self.content = ""
        } else {
            return nil
        }

    }
    
    init(user: MUser, content: String) {
        self.content = content
        sender = Sender(senderId: user.id, displayName: user.username)
        sentDate = Date()
        id = nil
    }
    
    init(user: MUser, image: UIImage) {
        sender = Sender(senderId: user.id, displayName: user.username)
        self.image = image
        content = ""
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

extension MMessage: Comparable {
    static func < (lhs: MMessage, rhs: MMessage) -> Bool {
        lhs.sentDate < rhs.sentDate
    }
    
    
}
