//
//  MChat.swift
//  iChat_App
//
//  Created by Felix Titov on 7/11/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

struct MChat: Hashable, Decodable {
    var username: String
    var userImageString: String
    var lastMessage: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        lhs.id == rhs.id
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true}
        if filter.isEmpty {
            return true
        }
        
        let lowecassedFilter = filter.lowercased()
        return username.lowercased().contains(lowecassedFilter)
    }
}
