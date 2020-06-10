//
//  CreateGoalController.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/28/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit


// modal presentation
class CreateGoalController: UIViewController {
    public var task: String?
    public var tasks = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
   
    // change to an array of type task later

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taskTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    private func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    

    @IBAction func addButtonPressed(_ sender: Any) {
        
        print("button pressed")
        print(tasks)
    
        if taskTextField?.text != "" {
            tasks.append(taskTextField.text ?? "no task")
           resetTaskTextField()
            
            
        } else {
            // Alert: Enter a task
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            alertController.message = "Enter a task"
            present(alertController, animated: true)
        }
    }
    
    private func resetTaskTextField() {
        taskTextField.text = nil
                   taskTextField.placeholder = "Add new Task"
    }
   

}
extension CreateGoalController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task
        return cell
    }
    
    
}

extension CreateGoalController: UITableViewDelegate {
    // change attributes of cell like height etc.
}

extension CreateGoalController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    // I need something that tells I need a delegate between the add button and the
}
