//
//  UIViewController+Extensions.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/24/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit


extension UIViewController {
    
    private static func resetWindow(with rootViewController: UIViewController) {
        guard let scene = UIApplication.shared.connectedScenes.first,
            let sceneDelegate = scene.delegate as? SceneDelegate,
            let window = sceneDelegate.window else {
                fatalError("could not reset window rootViewController")
        }
        
        window.rootViewController = rootViewController
    }
    
    public static func showViewController(storyBoardName: String, viewControllerId: String){
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let newVC = storyboard.instantiateViewController(identifier: viewControllerId)
        let navigationController = UINavigationController(rootViewController: newVC)
        resetWindow(with: navigationController)
    }
    
    
    public func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    
}
