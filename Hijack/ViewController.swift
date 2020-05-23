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
    @IBOutlet weak var hLabel: UILabel!
    
    @IBOutlet weak var iLabel: UILabel!
    @IBOutlet weak var jLabel: UILabel!
    
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var cLabel: UILabel!
    @IBOutlet weak var kLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "sunrise.png")!)
        updateUI()
    }

    func updateUI() {
        hLabel.font =  font
        hLabel.textDropShadow()
        iLabel.font = font
        iLabel.textDropShadow()
        jLabel.font = font
        jLabel.textDropShadow()
        aLabel.font = font
        aLabel.textDropShadow()
        cLabel.font = font
        cLabel.textDropShadow()
        kLabel.font = font
        kLabel.textDropShadow()
        profileImageView.image = UIImage(named: "sunProfile")
        profileImageView.roundImage()
    }
    
    

}




