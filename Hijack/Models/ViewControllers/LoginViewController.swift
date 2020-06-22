//
//  ViewController.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/16/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let font = UIFont(name: "AvenirNextCondensed-MediumItalic", size: 60)!
    
    
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var hijackImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    private var authSession = AuthenticationSession()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    func updateUI() {
        
        
        
        hijackImageView.image = UIImage(named: "hijackComfortaaFont")
        errorLabel.text = ""
        continueButton.isHidden = true
        continueButton.isEnabled = false
        
        
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else {
                print("missing fields")
                return
        }
        
        continueLoginFlowFromSignIn(email: email, password: password)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else {
                print("missing fields")
                return
        }
        
        continueLoginFlowFromCreate(email: email, password: password)
    }
    
    
    
    @IBAction func createButtonPressed(_ sender: Any) {
        
        errorLabel.text = "Enter a valid email address and password"
        errorLabel.textColor = .black
        continueButton.isEnabled = true
        continueButton.isHidden = false
        reassignButtons()
    }
    
    private func reassignButtons() {
        loginButton.isHidden = true
        loginButton.isEnabled = false
        createAccountButton.isHidden = true
        createAccountButton.isEnabled = false
        
    }
    
    private func navigateToMainView() {
        
        
        UIViewController.showViewController(storyBoardName: "MainView", viewControllerId: "HomeViewController")
    }
    
    private func continueLoginFlowFromSignIn(email: String, password: String){
        
        authSession.signInExistingUser(email: email, password: password) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorLabel.text = "Your login information is incorrect. Please re-enter or create a new account."
                    self?.errorLabel.textColor = .systemRed
                }
            case .success:
                DispatchQueue.main.async {
                    self?.navigateToMainView()
                    
                }
            }
        }
    }
    
    private func continueLoginFlowFromCreate(email: String, password: String) {
        authSession.createNewUser(email: email, password: password) {[weak self](result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorLabel.text = "\(error.localizedDescription)"
                    self?.errorLabel.textColor = .systemRed
                }
            case .success(let authDataResult):
                
                
                self?.createDatabaseUser(authDataResult: authDataResult)
                
                UIViewController.showViewController(storyBoardName: "MainView", viewControllerId: "HomeViewController")
                
            }
        }
    }
    
    private func createDatabaseUser(authDataResult: AuthDataResult) {
        DatabaseService.shared.createDatabaseUser(authDataResult: authDataResult) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Account error", message: "\(error)")
                }
            case .success:
                DispatchQueue.main.async {
                    self?.navigateToMainView()
                }
            }
        }
    }
    
    
    
    
}




