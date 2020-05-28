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
    private var menuItems = MenuItem.menuItems
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.goals = Goal.goals
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
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

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as? MenuCell else {
            fatalError("Unable to dequeue Menu Cell")
        }
        
        let menuItem = menuItems[indexPath.row]
        cell.configureCell(menuItem: menuItem)
        

        return cell
    }
    
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    // what goes here?
    // The set up for the collection view? Spacing and what not
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let interItemSpacing: CGFloat = 10 // space between items
      let maxWidth = UIScreen.main.bounds.size.width // device's width
      let numberOfItems: CGFloat = 3 // items
      let totalSpacing: CGFloat = numberOfItems * interItemSpacing
      let itemWidth: CGFloat = (maxWidth - totalSpacing) / numberOfItems
      
      return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) ->  UIEdgeInsets {
      return UIEdgeInsets(top: 20, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // when a cell is selected I want to segue to it's respective view controller
        
    }

    
}
