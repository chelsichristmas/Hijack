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

  
  
  static let goals = [
     Goal(name: "Redecorate Bedroom", dueDate: "04/13/2021", imageName: "bedroom"),
    Goal(name: "Go to Bali", dueDate: "10/20/2020", imageName: "bali"),
    Goal(name: "Create cool stuff", dueDate: "09/18/2025", imageName: "coolStuff")
  ]
  
    // I think I'd like to sort by due date (earliest to latest due date)
}
