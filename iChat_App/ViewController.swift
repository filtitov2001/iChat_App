//
//  ViewController.swift
//  iChat_App
//
//  Created by Felix Titov on 7/9/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        
    }


}

import SwiftUI

struct ViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = ViewController()
        
        func makeUIViewController(context: Context) -> some ViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
