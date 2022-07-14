//
//  WaitingChatsNavigation.swift
//  iChat_App
//
//  Created by Felix Titov on 7/14/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

protocol WaitingChatsNavigation: AnyObject {
    func removeWaitinfChats(chat: MChat)
    func chatToActive(chat: MChat)
}
