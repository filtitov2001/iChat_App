//
//  FirestoreService.swift
//  iChat_App
//
//  Created by Felix Titov on 7/12/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Firebase
import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    private init() {}
    
    func getUserData(user: User, completion: @escaping (Result<MUser, Error>) -> Void) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let mUser = MUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToMUser))
                    return
                }
                completion(.success(mUser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    
    func saveProfileWith(
        id: String,
        email: String,
        username: String?,
        avatarImageString: String?,
        description: String?,
        sex: String?,
        completion: @escaping (Result<MUser, Error>) -> Void
    ) {
        guard Validators.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        var mUser = MUser(
            username: username!,
            email: email,
            avatarStringURL: "Now exist",
            description: description!,
            sex: sex!,
            id: id
        )
        
        self.usersRef.document(mUser.id).setData(mUser.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(mUser))
            }
            
        }
    }
}