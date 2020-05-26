//
//  MainViewController.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/24/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var goals = [Goal]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.goals = Goal.goals
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func updateUI() {
//           self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.6838642359, green: 0.8506552577, blue: 0.6396567822, alpha: 1)
    }
    
    

}

extension HomeViewController: UITableViewDataSource{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as? GoalCell else {
            fatalError("Unable to deque Goal Cell")
        }
        
        let goal = goals[indexPath.row]
        cell.configureCell(goal: goal)
        return cell
      }
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}
