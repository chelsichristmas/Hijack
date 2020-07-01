//
//  GoalDetailViewController.swift
//  Hijack
//
//  Created by Chelsi Christmas on 6/1/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

class GoalDetailViewController: UIViewController {
    
    
    public var tasks = [Task]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var goal: Goal
    private var listener: ListenerRegistration?
    
    @IBOutlet weak var goalNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        taskListener(goal: goal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func updateUI() {
        
        // change constraints on label
        goalNameLabel.text = goal.goalName
        // the image
        
        goalImageView.kf.setImage(with: URL(string: goal.imageURL))
//        tasks = goal.tasks
        progressLabel.text = "Progress: \(goal.progress)%"
        progressBar.progress = Float(goal.progress)/100
    }
    
    init?(coder: NSCoder, goal: Goal) {
        self.goal = goal
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func taskListener(goal: Goal){
        
        print("task listener activated")
        let goalId = goal.goalId
        listener = Firestore.firestore().collection(DatabaseService.goalsCollection).document(goalId).collection(DatabaseService.tasksCollection).addSnapshotListener({ [weak self] (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Try again later", message: "\(error.localizedDescription)")
                }
            } else if let snapshot = snapshot {
                let tasks = snapshot.documents.map { Task($0.data())}
                self?.tasks = tasks
            }
        })
        
        
    }
    
    private func updateTaskStatus(_ status: String, documentId: String) {
        
        Firestore.firestore().collection(DatabaseService.goalsCollection).document(documentId).updateData(["status" : status]) { [weak self] (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Fail to update item", message: "\(error.localizedDescription)")
                }
            } else {
                print("all went well with the update")
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
            }
        }
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
        
        let task = tasks[indexPath.row]
        cell.configureDetailCell(task: task)
        
        return cell
    }
    
    
}

extension GoalDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 55
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // push up alert Controller or make it a button  on the far left of the cell
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
//           let cameraAction = UIAlertAction(title: "Camera", style: .default) { alertAction in
//             self.imagePickerController.sourceType = .camera
//             self.present(self.imagePickerController, animated: true)
//           }
                      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addToTodaysTasks = UIAlertAction(title: "Add to Today's Tasks", style: .default) { alertAction in
            // function for adding task to the today's tasks list
        }
        alertController.addAction(addToTodaysTasks)
           alertController.addAction(cancelAction)
           present(alertController, animated: true)
        
    }
    
    
}

extension HomeViewController: TaskCellDelegate {
func pressedStatusButton(_ taskCell: TaskCell, button: UIButton) {
    // what's happening here
    // when I press this the status should update
    // I still need access to the task here
    // I gotta use the index of the cell itself, which ever property lets me get that number will let me get into the array where I want
//    guard let indexPath = tableView.index
    
    taskCell.statusButtonPressed(button)
    

}
}
