//
//  GoalDetailViewController.swift
//  Hijack
//
//  Created by Chelsi Christmas on 6/1/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit

class GoalDetailViewController: UIViewController {
    
    
    public var tasks = [Task]()
    private var goal: Goal

    @IBOutlet weak var goalNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
    }
    
    
    private func updateUI() {
        
        // change constraints on label
        goalNameLabel.text = goal.name
        // the image
    }
    
    init?(coder: NSCoder, goal: Goal) {
       self.goal = goal
       super.init(coder: coder)
     }
     
     required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
     }

   
    // Table view where you can add, remove, and check off tasks. Second table view/section where you can see completed tasks and add tasks back if they weren't complrted properly or at all

    
    // UI
    // The cover photo for the goal is slighlty darkened
    // The goal name is on the image and the font color is white
    // directly below is the due date (The color fo rcomplete by can increase in brightness as it gets closer to the due date? like black to dark green to clover green to hijack green, MAYBE)
    // two table views one that shows complete tasks and one that shows not yet complete
    // button where a task can be added to home page for the days tasks
    
}

extension GoalDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskCell else {
            fatalError("Unable to deque task cell")
        }
        
        return cell
    }
}
