//
//  MainViewController.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/24/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var goals = [MockGoal]()
    private var tasks = [Task]()
    private var menuItems = MenuItem.menuItems
    
    @IBOutlet weak var taskTableView: UITableView!
    
    @IBOutlet weak var goalTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.goals = MockGoal.goals
        self.tasks = Task.bedroomTasks
        goalTableView.dataSource = self
        goalTableView.delegate = self
        taskTableView.delegate = self
        taskTableView.dataSource = self
    }
    
    private func updateUI() {
        //           self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.6838642359, green: 0.8506552577, blue: 0.6396567822, alpha: 1)
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
        let storyboard = UIStoryboard(name: "MainView", bundle: nil)
        if tableView == goalTableView {
            let vc = storyboard.instantiateViewController(identifier: "GoalDetailViewController") { (coder) in
                
                return GoalDetailViewController(coder: coder, goal: goal)
            }
            
            navigationController?.pushViewController(vc, animated: true)
            // when using a storyboard you have to instantiate the storyboard
            //        let vc = GoalDetailViewController()
            //
            //        navigationController?.pushViewController(vc, animated: true)
            //        performSegue(withIdentifier: "goalDetailSegue", sender: nil)
            
            
        }
    }
    
    
}









