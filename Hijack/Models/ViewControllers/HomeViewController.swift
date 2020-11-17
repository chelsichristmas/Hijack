//
//  MainViewController.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/24/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeViewController: UIViewController {
    // test comment
    
    
    private var goals = [Goal]() {
        didSet{
            DispatchQueue.main.async {
                self.goalTableView.reloadData()
            }
        }
    }
    
    private var listener: ListenerRegistration?
    private var tasks = [Task]()
    private var inMemoryTasks = [String]()
    public var arrayOfInMemoryTasks = [[String]]() {
        didSet {
            print(arrayOfInMemoryTasks)
        }
    }
    private var menuItems = MenuItem.menuItems
    
    @IBOutlet weak var taskTableView: UITableView!
    
    @IBOutlet weak var goalTableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(true)
        
        goalListener()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        listener?.remove() 
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalListener()
        goalTableView.dataSource = self
        goalTableView.delegate = self
    }
    private func goalListener() {
    listener = Firestore.firestore().collection(DatabaseService.goalsCollection).addSnapshotListener({ [weak self] (snapshot, error) in
      if let error = error {
        DispatchQueue.main.async {
          self?.showAlert(title: "Try again later", message: "\(error.localizedDescription)")
        }
      } else if let snapshot = snapshot {
        let goals = snapshot.documents.map { Goal($0.data()) }
         self?.goals = goals.sorted{  $0.createdDate.dateValue() > $1.createdDate.dateValue() }
      }
    })
        
    }
}

extension HomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == goalTableView {
            return goals.count
        } else {
            return tasks.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == goalTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as? GoalCell else {
                fatalError("Unable to deque Goal Cell")
            }
            
            let goal = goals[indexPath.row]
            cell.configureCell(goal: goal)
            return cell
        } else if tableView == taskTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskCell else {
                fatalError("Unable to deque Task Cell")
            }
            let task = tasks[indexPath.row]
            cell.configureCell(task: task)
            
            return cell
            
        }
        return UITableViewCell()
        
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == goalTableView{
            return 200
        } else if tableView == taskTableView {
            return 55
        }
        
        return CGFloat()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let goal = goals[indexPath.row]
        
        let goalTasks = self.tasks
        let storyboard = UIStoryboard(name: "MainView", bundle: nil)
        if tableView == goalTableView {
            let vc = storyboard.instantiateViewController(identifier: "GoalDetailViewController") { (coder) in

                return GoalDetailViewController(coder: coder, goal: goal, tasks: goalTasks)
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}











