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



class CreateGoalController: UIViewController {
    
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            coverPhotoImageView.image = selectedImage
        }
    }
    public var task: String?
    private var tasks = [Task]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    public var inMemoryTasks = [String]()
    private let homeVC = HomeViewController()
    private var goalId: String?
    private var listener: ListenerRegistration?
    
    
    public lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.addTarget(self, action: #selector(starButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var goalNameTextField: UITextField!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var createGoalButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //taskListener()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        cameraButtonCheck()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        listener?.remove()
    }
    private func cameraButtonCheck() {
        if goalNameTextField.text != "" && button.imageView?.image == UIImage(systemName: "star.fill") {
            cameraButton.isEnabled = true
            cameraButton.backgroundColor = .darkGray
        } else {
            cameraButton.isEnabled = false
        }
    }
    
    // TODO: Get feedback on whether or not this is necessary
    private func taskListener() {
        
        print("task listener activated")
        guard let goalId = goalId else {
            return
        }
        listener = Firestore.firestore().collection(DatabaseService.goalsCollection).document(goalId).collection(DatabaseService.tasksCollection).addSnapshotListener({ [weak self] (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Try again later", message: "\(error.localizedDescription)")
                }
            } else if let snapshot = snapshot {
                let tasks = snapshot.documents.map { Task($0.data())}
                self?.tasks = tasks
            }
        })
        
        
    }
    
    private func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        //  cameraButton.isHidden = false
        goalNameTextField.rightView = button
        goalNameTextField.rightViewMode = .always
        
        
    }
    
    
    @objc private func starButtonPressed() {
        
        guard let goalName = goalNameTextField.text,
            !goalName.isEmpty else {
                showAlert(title: "Missing Fields", message: "Enter goal name")
                //                   sender.isEnabled = true
                return
        }
        
        DatabaseService.shared.createGoal(goalName: goalName) { [weak self] (result) in
            switch result {
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error creating item", message: "Sorry something went wrong: \(error.localizedDescription)")
                }
            case .success(let goalId):
            DispatchQueue.main.async {
                    self?.goalId = goalId
                    self?.button.isEnabled = false
                    self?.button.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    self?.cameraButton.isEnabled = true
                    self?.cameraButton.backgroundColor = .darkGray
                    self?.coverPhotoImageView.alpha = 1.0
                }
                
                
            }
        }
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
        
        guard let selectedImage = selectedImage,
            let goalId = goalId else {
                //TODO: add code for error
                return
        }
        
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: coverPhotoImageView.bounds)
        
        self.uploadPhoto(photo: resizedImage, documentId: goalId)
        
        
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
                print("all went well with the update")
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        print("button pressed")
        
        
        guard let goalId = goalId,
            let taskDescription = taskTextField.text else {
                return
        }
        
        if taskDescription != "" {
            DatabaseService.shared.addTask(goalId: goalId, taskDescription: taskDescription) { (result) in
                switch result {
                case .failure(let error):
                    print("fail: \(error)")
                case .success:
                    // TODO: Come back to ensure the right date is being added to the task when it's created
                    let task = Task(description: taskDescription, status: "notCompleted", createdDate: Timestamp(date: Date()))
                    self.tasks.append(task)
                    print("task successfully added")
                    self.taskListener()
                self.tableView.reloadData()
                }
            }
//
            resetTaskTextField()
            
            
        } else {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            alertController.message = "Enter a goal task"
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskCell  else  {
          fatalError("Unable to deque Task Cell")
        }
        let task = tasks[indexPath.row]
//        cell.textLabel?.text = task
        cell.configureCell(task: task)
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
        
        dismiss(animated: true)
    }
}
