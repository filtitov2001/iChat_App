//
//  LoginViewController.swift
//  iChat_App
//
//  Created by Felix Titov on 7/9/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {

    let welcomeLabel = UILabel(text: "Welcome back!", font: .avenir26())
    
    let loginWithlLabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "Or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let needAnAccountLabel = UILabel(text: "Need an account?")
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .buttonDark())
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
        return button
    }()
    
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    
    weak var delegate: AuthNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleButton.cutomizedGoogleButton()
        view.backgroundColor = .systemBackground
        setupConstraints()
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        AuthService.shared.login(email: emailTextField.text, password: passwordTextField.text) { result in
            switch result {
            case .success(let user):
                self.showAlert(with: "Success!", and: "You've signed in!") {
                    FirestoreService.shared.getUserData(user: user) { result in
                        switch result {
                            
                        case .success(let mUser):
                            let mainTabBarController = MainTabBarController(currentUser: mUser)
                            mainTabBarController.modalPresentationStyle = .fullScreen
                            self.present(mainTabBarController, animated: true)
                        case .failure(_):
                            self.present(SetupProfileViewController(currentUser: user), animated: true)
                        }
                    }
                    
                }
                
            case .failure(let error):
                self.showAlert(with: "Error!", and: error.localizedDescription)
            }
        }
    }
    
    @objc private func signUpButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
    }
}

//MARK: - Setup constraints
extension LoginViewController {
    private func setupConstraints() {
        let loginWithView = ButtonFormView(label: loginWithlLabel, button: googleButton)
        let emailStackView = UIStackView(
            arrangedSubviews: [emailLabel, emailTextField],
            axis: .vertical,
            spacing: 0
        )
        let passwordStackView = UIStackView(
            arrangedSubviews: [passwordLabel, passwordTextField],
            axis: .vertical,
            spacing: 0
        )
        
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(
            arrangedSubviews: [
                loginWithView,
                orLabel,
                emailStackView,
                passwordStackView,
                loginButton
            ],
            axis: .vertical,
            spacing: 40
        )
        
        signUpButton.contentHorizontalAlignment = .leading
        
        let bottomStackView = UIStackView(
            arrangedSubviews: [
                needAnAccountLabel,
                signUpButton
            ],
            axis: .horizontal,
            spacing: 10
        )
        bottomStackView.alignment = .firstBaseline
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 60),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
}

//MARK: - GoogleSignIn
extension LoginViewController: GoogleSignInDelegate {
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
                                mainTabBarController.modalPresentationStyle = .fullScreen
                                UIApplication.getTopViewController()?.present(mainTabBarController, animated: true)
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

struct LoginControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = LoginViewController()
        
        func makeUIViewController(context: Context) -> some LoginViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
