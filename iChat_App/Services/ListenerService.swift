//
//  ListenerService.swift
//  iChat_App
//
//  Created by Felix Titov on 7/13/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListenerService {
    static let shared = ListenerService()
    
    private init() {}
    
    private let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    func usersObserve(users: [MUser], completion: @escaping (Result<[MUser], Error>) -> Void) -> ListenerRegistration?  {
        var users = users
        let usersListener = usersRef.addSnapshotListener { querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            querySnapshot.documentChanges.forEach { differense in
                guard let mUser = MUser(document: differense.document) else { return }
                switch differense.type {
                    
                case .added:
                    guard !users.contains(mUser) else { return }
                    guard mUser.id != self.currentUserId else { return }
                    users.append(mUser)
                case .modified:
                    guard let index = users.firstIndex(of: mUser) else { return }
                    users[index] = mUser
                case .removed:
                    guard let index = users.firstIndex(of: mUser) else { return }
                    users.remove(at: index)
                }
            }
            
            completion(.success(users))
        }
        
        return usersListener
    }
}