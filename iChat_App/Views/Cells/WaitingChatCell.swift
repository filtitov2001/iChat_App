//
//  WaitingChatCell.swift
//  iChat_App
//
//  Created by Felix Titov on 7/10/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

class WaitingChatCell: UICollectionViewCell, SelfConfigureCell {
    static var reuseID: String = "WaitingChatCell"
    
    let friendImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .tertiarySystemBackground
        
        self.layer.cornerRadius = frame.height / 2
        self.clipsToBounds = true
        setupConstatraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure<U>(with value: U) where U : Hashable {
            guard let chat: MChat = value as? MChat else { return }
    //        friendImageView.image = UIImage(named: chat.userImageString)
        }
    
    private func setupConstatraints() {
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(friendImageView)
        
        NSLayoutConstraint.activate([
            friendImageView.topAnchor.constraint(equalTo: self.topAnchor),
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            friendImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        friendImageView.layer.cornerRadius = friendImageView.frame.height / 2
        friendImageView.layer.masksToBounds = true
    }
    
}

//MARK: - SwiftUI
import SwiftUI

struct WaitingChatControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = MainTabBarController()
        
        func makeUIViewController(context: Context) -> some MainTabBarController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
