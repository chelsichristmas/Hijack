//
//  GoalCell.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/25/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class GoalCell: UITableViewCell {
    private let progressValue = Float(0)
    
    @IBOutlet weak var goalImageView: UIImageView!
    
    @IBOutlet weak var goalNameLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    public func configureCell(goal: Goal) {
        goalImageView.kf.setImage(with: URL(string: goal.imageURL))
        goalImageView.alpha = 0.8
        goalImageView.roundImage()
        goalNameLabel.text = goal.goalName
        progressLabel.text = "Progress: \(Int(goal.progress))%"
        progressBar.setProgress(Float(goal.progress/100), animated: true)
    }
}
