//
//  ViewController.swift
//  iChat_App
//
//  Created by Felix Titov on 7/9/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase

class AuthViewController: UIViewController {
    
    private let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFill)
    
    private let orLabel = UILabel(text: "OR", font: .avenir15())
    private let alreadyOnBoardLabel = UILabel(text: "Already have an account?")
    
    private let googleButton = UIButton(
        title: "Login with Google",
        titleColor: .black,
        backgroundColor: .white,
        isShadow: true
    )
    
    private let emailButton = UIButton(
        title: "Sign up with Email",
        titleColor: .white,
        backgroundColor: .buttonDark(),
        isShadow: true
    )
    
    private let loginButton = UIButton(
        title: "Login",
        titleColor: .buttonRed(),
        backgroundColor: .white,
        isShadow: true
    )
    
    private let signUpVC = SignUpViewController()
    private let loginVC = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraintsForButtons()
        setupConstraints()
        setupUI()
        
        signUpVC.delegate = self
        loginVC.delegate = self
        
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
    }
    
    @objc private func emailButtonTapped() {
        present(signUpVC, animated: true)
    }
    
    @objc private func loginButtonTapped() {
        present(loginVC, animated: true)
    }
}

//MARK: - Work with UI
extension AuthViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        googleButton.cutomizedGoogleButton()
        emailButton.applyGradients(cornerRadius: 15)
        
        orLabel.minimumScaleFactor = 0.5
        orLabel.textAlignment = .center
        
        alreadyOnBoardLabel.minimumScaleFactor = 0.5
        alreadyOnBoardLabel.textAlignment = .center
        
    }
    
    private func setupConstraintsForButtons() {
        googleButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        emailButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        let signUpStackView = UIStackView(
            arrangedSubviews: [googleButton, orLabel, emailButton], axis: .vertical,
        spacing: 10)
        signUpStackView.translatesAutoresizingMaskIntoConstraints = false
        signUpStackView.alignment = .fill
        signUpStackView.distribution = .equalSpacing
        
        let loginStackView = UIStackView(
            arrangedSubviews: [
                alreadyOnBoardLabel,
                loginButton
            ],
            axis: .vertical,
            spacing: 10
        )
        loginStackView.translatesAutoresizingMaskIntoConstraints = false
        loginStackView.alignment = .fill
        loginStackView.distribution = .equalSpacing
        
        let mainStackView = UIStackView(
            arrangedSubviews: [
                signUpStackView,
                loginStackView
            ],
            axis: .vertical,
            spacing: 40
        )
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.alignment = .fill
        mainStackView.distribution = .equalSpacing
        
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 30),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35),
            mainStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.536972, constant: 0)
        ])
        
    }
    
}

//MARK: - AuthNavigationDelegate
extension AuthViewController: AuthNavigationDelegate {
    func toLoginVC() {
        present(loginVC, animated: true)
    }
    
    func toSignUpVC() {
        present(signUpVC, animated: true)
    }
}

//MARK: - GoogleSignIn
extension AuthViewController: GoogleSignInDelegate {
    @objc func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            
            AuthService.shared.loginWithGoogle(user: user, error: error) { result in
                switch result {
                case .success(let user):
                    FirestoreService.shared.getUserData(user: user) { result in
                        switch result {
                            
                        case .success(let mUser):
                            UIApplication.getTopViewController()?.showAlert(with: "Success!", and: "You've signed in!") {
                                let mainTabBarController = MainTabBarController(currentUser: mUser)
                                self.changeRootViewController(rootViewController: mainTabBarController)
                            }
                        case .failure(_):
                            UIApplication.getTopViewController()?.showAlert(with: "Success!", and: "You've signed up!") {
                                UIApplication.getTopViewController()?.present(SetupProfileViewController(currentUser: user), animated: true)
                            }
                        }
                    }
                case .failure(let error):
                    self.showAlert(with: "Error!", and: error.localizedDescription)
                }
            }
        }
    }
}

//MARK: - SwiftUI
import SwiftUI

struct ViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
            .previewDisplayName("iPhone 13")
            .edgesIgnoringSafeArea(.all)

        ContainerView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (1st generation)"))
            .previewDisplayName("iPhone SE (1st generation)")
            .edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = AuthViewController()
        
        func makeUIViewController(context: Context) -> some AuthViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
