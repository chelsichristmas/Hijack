//
//  Goal.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/25/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import Foundation



// Dummy Goals Model
struct MockGoal{
  let goalName: String
    let goalId: String?
    let dueDate: String
    let imageName: String
    let status: String
    let progress: Int
    let tasks: [Task]

  // progress equals completed tasks didvided by total tasks(completed&not completed) times 100
    // each goal needs to have a property for compleetd tasks an a propperty for not completed tasks rather than an overall tasks property
  
//  static let goals = [
//    MockGoal(goalName: "Redecorate Bedroom", goalId: nil, dueDate: "04/13/2021", imageName: "bedroom", status: "active",progress: 50, tasks: Task.bedroomTasks),
//    MockGoal(goalName: "Go to Bali", goalId: nil, dueDate: "10/20/2020", imageName: "bali", status: "active", progress: 35, tasks: Task.baliTasks),
//    MockGoal(goalName: "Create cool stuff", goalId: nil, dueDate: "09/18/2025", imageName: "coolStuff", status: "completed", progress: 90, tasks: Task.coolTasks)
//  ]
  
    // I think I'd like to sort by due date (earliest to latest due date)
}

struct Task {
    let description: String // name/description of task
    let status: String // not completed or completed
    
    static let bedroomTasks = [Task(description: "Save $150", status: "notCompleted"), Task(description: "Remove old furniture", status: "notCompleted"), Task(description: "Order star lamp", status: "completed")]
//
//    static let baliTasks = [Task(description: "Book a flight", status: .completed), Task(description: "Choose hotel", status: .notCompleted), Task(description: "Invite a friend", status: .notCompleted)]
//
//    static let coolTasks = [Task(description: "Purchase chrome paint", status: .completed), Task(description: "Attend interesting lectures", status: .notCompleted), Task(description: "Dissect old devices", status: .notCompleted)]
}

enum TaskStatus: String {
    case completed = "completed"
    case notCompleted = "not completed"
}
extension Task {
    init(_ dictionary: [String: Any]) {
    self.description = dictionary["description"] as? String ?? "no item name"
        self.status = dictionary["status"] as? String ?? "no status"
    }
}
