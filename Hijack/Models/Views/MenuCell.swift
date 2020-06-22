//
//  MenuCell.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/27/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    public func configureCell(menuItem: MenuItem) {
        nameLabel.text = menuItem.name
        self.backgroundColor = #colorLiteral(red: 0.6838642359, green: 0.8506552577, blue: 0.6396567822, alpha: 1)
    }
}
