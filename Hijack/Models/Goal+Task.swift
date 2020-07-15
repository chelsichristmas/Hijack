//
//  Goal.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/25/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import Foundation
import Firebase


struct Task {
    let description: String // name/description of task
    let status: Bool // not completed or completed
    let taskId: String
    let createdDate: Timestamp
    
}

enum TaskStatus: String {
    case completed = "completed"
    case notCompleted = "not completed"
}
extension Task {
    init(_ dictionary: [String: Any]) {
    self.description = dictionary["description"] as? String ?? "no item name"
        self.status = dictionary["status"] as? Bool ?? false
        self.taskId = dictionary["taskId"] as? String ?? "no taskId"
        self.createdDate = dictionary["createdDate"] as? Timestamp ?? Timestamp(date: Date())
    }
}
