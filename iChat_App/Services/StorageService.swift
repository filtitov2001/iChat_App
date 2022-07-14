//
//  StorageService.swift
//  iChat_App
//
//  Created by Felix Titov on 7/12/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit
import FirebaseStorage
import FirebaseAuth

class StorageService {
    
    static let shared = StorageService()

    let storageRef = Storage.storage().reference()
    
    private var avatarsRef: StorageReference {
        return storageRef.child("avatars")
    }
    
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    private var chatsRef: StorageReference {
        return storageRef.child("chats")
    }
    
    func upload(photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let scaledImage = photo.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        avatarsRef.child(currentUserId).putData(imageData, metadata: metadata) { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            self.avatarsRef.child(self.currentUserId).downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            }
        }
    }
    
    func uploadImageMessage(photo: UIImage, to chat: MChat, completion: @escaping (Result<URL, Error>) -> Void ) {
        guard let scaledImage = photo.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let uid: String = Auth.auth().currentUser!.uid
        let chatName = [chat.friendUsername, uid].joined()
        self.chatsRef.child(chatName).child(imageName).putData(imageData, metadata: metadata) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            self.chatsRef.child(chatName).child(imageName).downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            }
        }
        
    }
    
    func downloadImage(url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let MB = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: MB) { data, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(UIImage(data: data)))
        }
    }
}

