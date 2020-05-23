//
//  UILabel+Extensions.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/21/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit
extension UILabel {
func textDropShadow() {
    self.layer.masksToBounds = false
    self.layer.shadowRadius = 10.0
    self.layer.shadowOpacity = 0.7
    self.layer.shadowOffset = CGSize(width: 1, height: 2)
//    self.layer.shadowColor = bla
}
}
