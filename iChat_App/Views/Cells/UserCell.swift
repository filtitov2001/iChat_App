//
//  UserCell.swift
//  iChat_App
//
//  Created by Felix Titov on 7/11/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

class UserCell: UICollectionViewCell, SelfConfigureCell {
    
    let userImageView = UIImageView()
    let username = UILabel(text: "Felix", font: .laoSangamMN20())
    let containerView = UIView()
    
    static var reuseID: String = "userCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .tertiarySystemBackground
        setupConstraints()
        
        self.layer.cornerRadius = 4
        self.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.containerView.layer.cornerRadius = 4
        self.containerView.clipsToBounds = true
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        userImageView.layer.masksToBounds = true
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let user: MUser = value as? MUser else { return }
        userImageView.image = UIImage(named: user.avatarStringURL)
        username.text = user.username
        
    }
    
    private func setupConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        username.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        addSubview(userImageView)
        containerView.addSubview(username)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            userImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            username.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            username.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            username.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            username.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
}


//MARK: - SwiftUI
import SwiftUI

struct UserChatControllerProvider: PreviewProvider {
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
