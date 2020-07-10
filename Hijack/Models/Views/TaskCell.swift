//
//  TaskCell.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/28/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit

protocol TaskCellDelegate: AnyObject {
    func pressedStatusButton(_ taskCell: TaskCell, button: UIButton)
}

class TaskCell: UITableViewCell {
    
    weak var delegate: TaskCellDelegate?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    public func configureCell(task: Task) {
        descriptionLabel.text = task.description
    }
    
    public func configureDetailCell(task: Task) {
        detailDescriptionLabel.text = task.description
        if task.status == true {
            statusButton.setImage(UIImage(named: "checkedBox"), for: .normal)
        } else {
            statusButton.setImage(UIImage(named: "uncheckedBox"), for: .normal)
        }
    }
    
    //TODO: decide whether or not to use funtion for updating UI
    func hasTaskBeenCompleted(_ task: Task) -> Bool {
            if task.status == true {
                return true
            } else {
                return false
            }

    }
        
        
      public func statusChange(task: Task) {
            if hasTaskBeenCompleted(task){
                       
                statusButton.setImage(UIImage(systemName: "uncheckedBox"), for: .normal)
                //DatabaseService.
                       
                       
                // update the status on firebase
                
                       
                   } else {
                        statusButton.setImage(UIImage(systemName: "checkedBox"), for: .normal)
                           

                   }
                   
                   
               }
            
    
@IBAction func statusButtonPressed(_ sender: UIButton) {
        delegate?.pressedStatusButton(self, button: sender)
        
    }
}
