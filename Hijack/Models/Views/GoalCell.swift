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
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    public func configureCell(goal: MockGoal) {
        
        goalImageView.image = UIImage(named: goal.imageName)
        goalImageView.alpha = 0.8
        goalImageView.roundImage()
        goalNameLabel.text = goal.goalName
        progressLabel.text = "Progress: \(goal.progress)%"
        progressBar.progress = Float(goal.progress)/100
    }
}
