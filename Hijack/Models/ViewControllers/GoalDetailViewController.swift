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
    public var goalId: String?
    private var listener: ListenerRegistration?
    private var delegate: TaskCellDelegate?
    
    
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
        goalId = goal.goalId
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func updateUI() {
        goalNameLabel.text = goal.goalName
        goalImageView.kf.setImage(with: URL(string: goal.imageURL))
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
    
    private func deleteOriginalGoal(goal: Goal){
        DatabaseService.shared.delete(goal: goal) {[weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error saving item", message: "Sorry something went wrong: \(error.localizedDescription)")
                }
            case .success:
                print(" Saved successfully")
            }
        }
    }
    
    private func updateTaskStatus(taskId: String, goalId: String, status: Bool) {
        
        Firestore.firestore().collection(DatabaseService.goalsCollection).document(goalId).collection(DatabaseService.tasksCollection).document(taskId).updateData(["status" : status]) { [weak self] (error) in
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
        cell.delegate = self
        return cell
    }
}

extension GoalDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension GoalDetailViewController: TaskCellDelegate {
    
    func hasTaskBeenCompleted(_ task: Task) -> Bool {
        if task.status == true {
            print("pressed complete")
            return true
        } else {
            print("pressed incomplete")
            return false
        }
    }
    
    func pressedStatusButton(_ taskCell: TaskCell, button: UIButton) {
        print("pressed")
        
        guard let indexPath = self.tableView.indexPath(for: taskCell) else {
            fatalError("No index path available")
        }
        
        guard let goalId = goalId else {
            fatalError("No available goalId")
        }
        let task = self.tasks[indexPath.row]
        
        if hasTaskBeenCompleted(task){
            taskCell.statusButton.setImage(UIImage(named: "unheckedBox"), for: .normal)
            self.updateTaskStatus(taskId: task.taskId, goalId: goalId, status: false)
            
        } else {
            taskCell.statusButton.setImage(UIImage(named: "checkedBox"), for: .normal)
            
            self.updateTaskStatus(taskId: task.taskId, goalId: goalId, status: true)
        }
    }
}
