//
//  ProfileViewController.swift
//  Hijack
//
//  Created by Chelsi Christmas on 6/11/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            UIViewController.showViewController(storyBoardName: "Main", viewControllerId: "LoginViewController")
        } catch {
            DispatchQueue.main.async {
                self.showAlert(title: "Error signing out", message: "\(error.localizedDescription)")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
