//
//  TaskCell.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/28/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    public func configureCell(task: Task) {
        descriptionLabel.text = task.description
    }
    
    public func configureDetailCell(task: Task) {
        detailDescriptionLabel.text = task.description
    }

}
