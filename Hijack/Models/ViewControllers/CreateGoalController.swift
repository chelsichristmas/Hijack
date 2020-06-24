//
//  CreateGoalController.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/28/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


// modal presentation
class CreateGoalController: UIViewController {
    
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self // conform to UIImagePickerContorllerDelegate and UINavigationControllerDelegate
        return picker
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            coverPhotoImageView.image = selectedImage
        }
    }
    public var task: String?
    public var tasks = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    
    // change to an array of type task later
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var goalNameTextField: UITextField!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var createButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    private func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        cameraButton.isHidden = false
    }
    
    
    @IBAction func selectCoverPhotoButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { alertAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { alertAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        
        guard let goalName = goalNameTextField.text,
            !goalName.isEmpty,  let selectedImage = selectedImage else {
                showAlert(title: "Missing Fields", message: "All fields are required along with a photo.")
                //                   sender.isEnabled = true
                return
        }
        
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: coverPhotoImageView.bounds)
        
        DatabaseService.shared.createGoal(goalName: goalName, imageName: "imageName", status: "incomplete", progress: 20, tasks: Task.bedroomTasks) { (result) in
            switch result {
            case.failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error creating item", message: "Sorry something went wrong: \(error.localizedDescription)")
                }
            case .success(let documentId):
                self.uploadPhoto(photo: resizedImage, documentId: documentId)
                print("success, documentId = \(documentId)")
                
            }
        }
        
        
    }
    
    private func uploadPhoto(photo: UIImage, documentId: String) {
        StorageService.shared.uploadPhoto(itemId: documentId, image: photo) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
                }
            case .success(let url):
                self?.updateItemImageURL(url, documentId: documentId)
            }
        }
    }
    
    private func updateItemImageURL(_ url: URL, documentId: String) {
        
        Firestore.firestore().collection(DatabaseService.goalsCollection).document(documentId).updateData(["imageURL" : url.absoluteString]) { [weak self] (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Fail to update item", message: "\(error.localizedDescription)")
                }
            } else {
                // everything went ok
                print("all went well with the update")
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
            }
        }
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
    
}

extension CreateGoalController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("could not attain original image")
        }
        selectedImage = image
        cameraButton.isHidden = true
        dismiss(animated: true)
    }
}
