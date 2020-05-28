//
//  MenuItem.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/27/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit

struct MenuItem {
    
    let name: String?
    let controllerName: String?
    let color: UIColor?
   
    
    static let menuItems = [
        MenuItem(name: "Vision Board", controllerName: "VisionBoardViewController", color: #colorLiteral(red: 0.9982728362, green: 0.8502804637, blue: 0.3993353546, alpha: 1)),
        MenuItem(name: "Lists", controllerName: "ListsViewController", color: #colorLiteral(red: 0.7082617879, green: 0.65360111, blue: 0.8412203193, alpha: 1)),
        MenuItem(name: "Routines", controllerName: "RoutinesViewController", color: #colorLiteral(red: 0.7165017724, green: 0.8414298892, blue: 0.6578611135, alpha: 1)),
        MenuItem(name: "Games", controllerName: "GamesViewController", color: #colorLiteral(red: 0.4646292329, green: 0.6474331021, blue: 0.6882066727, alpha: 1))
    ]
}
