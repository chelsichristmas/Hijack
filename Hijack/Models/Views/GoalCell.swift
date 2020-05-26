//
//  GoalCell.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/25/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {
    
    
    @IBOutlet weak var goalImageView: UIImageView!
    
    @IBOutlet weak var goalNameLabel: UILabel!
    public func configureCell(goal: Goal) {
        
        goalImageView.image = UIImage(named: goal.imageName)
        goalImageView.alpha = 0.8
        goalNameLabel.text = goal.name
    }
}
