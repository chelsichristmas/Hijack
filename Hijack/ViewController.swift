//
//  ViewController.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/16/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let font = UIFont(name: "AvenirNextCondensed-MediumItalic", size: 60)!
    

    
    @IBOutlet weak var createButtonImageView: UIImageView!
    @IBOutlet weak var loginButtonImageView: UIImageView!
    @IBOutlet weak var hiJackImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }

    func updateUI() {

      
   
        hiJackImageView.image = UIImage(named: "hijackComfortaaFont")
        
        loginButtonImageView.image = UIImage(named: "loginButtonShadow")
        createButtonImageView.image = UIImage(named: "createAccountButtonShadow")
        
    }
    
    

}




