//
//  Extension + UIViewController.swift
//  iChat_App
//
//  Created by Felix Titov on 7/11/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

extension UIViewController {
    func configure<T: SelfConfigureCell, U: Hashable>(collectionView: UICollectionView, cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseID, for: indexPath) as? T else {
            fatalError()
        }
        
        cell.configure(with: value)
        return cell
    }
    
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void  = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func changeRootViewController(rootViewController: UIViewController) {
        let rootVC = rootViewController
        rootVC.modalPresentationStyle = .fullScreen
        rootVC.modalTransitionStyle = .coverVertical
        UIApplication.getTopViewController()?.present(rootVC, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIApplication.shared.connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }?.rootViewController = rootVC
        }
    }
}
