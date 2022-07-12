//
//  Extension + UIApplication.swift
//  iChat_App
//
//  Created by Felix Titov on 7/12/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

extension UIApplication {
    
    class func getTopViewController(
        base: UIViewController? = UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
