//
//  UIImageView+Extensions.swift
//  Hijack
//
//  Created by Chelsi Christmas on 6/19/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit
import AVFoundation

extension UIImageView {

    func roundImage() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        self.layer.cornerRadius = self.frame.height / 9
        self.clipsToBounds = true
    }
    
}
