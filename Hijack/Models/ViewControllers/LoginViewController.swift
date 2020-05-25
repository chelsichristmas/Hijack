//
//  ViewController.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/16/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let font = UIFont(name: "AvenirNextCondensed-MediumItalic", size: 60)!
    

    

    @IBOutlet weak var hijackImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }

    func updateUI() {

      
   
        hijackImageView.image = UIImage(named: "hijackComfortaaFont")
        
      
        
    }
    

    @IBAction func loginButtonPressed(_ sender: Any) {
        // go to the main view storyboard
                navigateToMainView()
    }
    
    private func navigateToMainView() {
        
        
       UIViewController.showViewController(storyBoardName: "MainView", viewControllerId: "MainViewController")
     }
    

}




