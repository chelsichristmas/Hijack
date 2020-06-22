//
//  Goal.swift
//  Hijack
//
//  Created by Chelsi Christmas on 6/11/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import Foundation

struct Goal {

let goalName: String
let goalId: String
let imageURL: String
let status: String
let progress: Int
let tasks: [Task]

}

extension Goal {
    init(_ dictionary: [String: Any]) {
        self.goalName = dictionary["goalName"] as? String ?? "no item name"
            self.goalId = dictionary["goalId"] as? String ?? "no goal id"
        self.imageURL = dictionary["imageName"] as? String ?? "no image URL"
        self.status = dictionary["status"] as? String ?? "no status available"
        self.progress = dictionary["progress"] as? Int ?? 0
        self.tasks = dictionary["tasks"] as? [Task] ?? Task.bedroomTasks
    }
}
