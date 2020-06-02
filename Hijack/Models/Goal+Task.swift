//
//  Goal.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/25/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import Foundation



// Dummy Goals Model
struct Goal{
  let name: String
    let dueDate: String
    let imageName: String
    let status: String
    let progress: Int
    let tasks: [Task]

  
  
  static let goals = [
    Goal(name: "Redecorate Bedroom", dueDate: "04/13/2021", imageName: "bedroom", status: "active",progress: 15, tasks: Task.bedroomTasks),
    Goal(name: "Go to Bali", dueDate: "10/20/2020", imageName: "bali", status: "active", progress: 20, tasks: Task.baliTasks),
    Goal(name: "Create cool stuff", dueDate: "09/18/2025", imageName: "coolStuff", status: "completed", progress: 12, tasks: Task.coolTasks)
  ]
  
    // I think I'd like to sort by due date (earliest to latest due date)
}

struct Task {
    let description: String // name/description of task
    let status: String // not completed or completed
    
    static let bedroomTasks = [Task(description: "Save $150", status: "not complete"), Task(description: "Remove old furniture", status: "not complete"), Task(description: "Order star lamp", status: "not complete")]
    
    static let baliTasks = [Task(description: "Book a flight", status: "complete"), Task(description: "Choose hotel", status: "not complete"), Task(description: "Invite a friend", status: "not complete")]
    
    static let coolTasks = [Task(description: "Purchase chrome paint", status: "complete"), Task(description: "Attend interesting lectures", status: "not complete"), Task(description: "Dissect old devices", status: "not complete")]
}
