//
//  UIImage+Extensions.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/21/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit

extension UIImageView {

    func roundImage() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
