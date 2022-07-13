//
//  MChat.swift
//  iChat_App
//
//  Created by Felix Titov on 7/11/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

struct MChat: Hashable, Decodable {
    var friendUsername: String
    var friendAvatarStringURL: String
    var lastMessageContent: String
    var friendId: String
    
    var representation: [String: Any] {
        var rep = ["friendUsername": friendUsername]
        rep["friendAvatarStringURL"] = friendAvatarStringURL
        rep["lastMessage"] = lastMessageContent
        rep["friendId"] = friendId
        
        return rep
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        lhs.friendId == rhs.friendId
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true}
        if filter.isEmpty {
            return true
        }
        
        let lowecassedFilter = filter.lowercased()
        return friendUsername.lowercased().contains(lowecassedFilter)
    }
}
