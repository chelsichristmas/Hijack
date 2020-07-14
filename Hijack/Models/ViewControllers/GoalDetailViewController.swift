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
    private var progress = Float(0) {
        didSet {
            DispatchQueue.main.async {
                self.progressBar.setProgress(self.progress, animated: true)
            }
        }
    }
    
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
        progressBar.progress = Float(progress)
        progressLabel.text = "Progress: 0%"
        print("Progress = \(progress)")
    }
    
    init?(coder: NSCoder, goal: Goal, tasks: [Task]) {
        self.goal = goal
        self.tasks = tasks
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func taskListener(goal: Goal){
        
        
        let goalId = goal.goalId
        listener = Firestore.firestore().collection(DatabaseService.goalsCollection).document(goalId).collection(DatabaseService.tasksCollection).addSnapshotListener({ [weak self] (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Try again later", message: "\(error.localizedDescription)")
                }
            } else if let snapshot = snapshot {
                let tasks = snapshot.documents.map { Task($0.data())}
                self?.tasks = tasks
                self?.calculateGoalProgress(tasks: self!.tasks)
            }
        })
    }
    
    private func updateTaskStatus(taskId: String, goalId: String, status: Bool) {
        
        Firestore.firestore().collection(DatabaseService.goalsCollection).document(goalId).collection(DatabaseService.tasksCollection).document(taskId).updateData(["status" : status]) { [weak self] (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Fail to update item", message: "\(error.localizedDescription)")
                }
            } else {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    private func calculateGoalProgress(tasks: [Task]) {
        let goalTasks = tasks
        let totalNumberOfTasks = Float(tasks.count)
        var numberOfCompletedTasks = Float(0)
        var progressValue = Float(0)
        
        for task in goalTasks {
            if hasTaskBeenCompleted(task) {
                numberOfCompletedTasks += 1
                DispatchQueue.main.async {
                    if numberOfCompletedTasks == 0 {
                        progressValue = 0
                        self.progressBar.setProgress(progressValue, animated: true)
                    } else {
                        progressValue = numberOfCompletedTasks/totalNumberOfTasks
                        self.progressBar.setProgress(progressValue, animated: true)
                    }
                }
            } else {
                self.progressBar.setProgress(progressValue, animated: true)
            }
        }
        setupLabel(progressValue: progressValue)
    }
    
    private func setupLabel(progressValue: Float) {
       DispatchQueue.main.async {
        self.progressLabel.text = "Progress: \(Int(progressValue * 100))%"
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
            return true
        } else {
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
