//
//  Extension + UIView.swift
//  iChat_App
//
//  Created by Felix Titov on 7/11/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

extension UIView {
    func applyGradients(cornerRadius: CGFloat) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1), endColor: #colorLiteral(red: 0.4784313725, green: 0.6980392157, blue: 0.9215686275, alpha: 1))
        if let gradientLayer = gradientView.layer.sublayers?.compactMap({ $0 as? CAGradientLayer}).first {
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRadius
            
            self.layer.insertSublayer(gradientLayer, at: 0)
            
        }
    }
}

//MARK: - SwiftUI
import SwiftUI

struct TestViewControllerProvider: PreviewProvider {
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
