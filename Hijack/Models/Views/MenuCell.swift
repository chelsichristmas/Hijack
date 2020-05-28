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
        self.backgroundColor = menuItem.color
    }
}
