//
//  DatabaseServices.swift
//  Hijack
//
//  Created by Chelsi Christmas on 6/11/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
    
    static let goalsCollection = "goals"
    static let usersCollection = "users"
    static let tasksCollection = "tasks"
    
    // review - firebase firestore hierarchy
    // top level
    // collection -> document -> collection -> document ->......
    
    // let's get a reference to the Firebase Firestore database
    
    private let db = Firestore.firestore()
    
    private init() {}
    static let shared = DatabaseService()
    
    public func createGoal(goalName: String,
                           imageName: String,
                           status: String,
                           progress: Int,
                           tasks: [Task],
                           
                           completion: @escaping (Result<String, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        
        let documentRef = db.collection(DatabaseService.goalsCollection).document()
        
        db.collection(DatabaseService.goalsCollection)
            .document(documentRef.documentID)
            .setData(["goalName":goalName,
                      "imageName": imageName,
                      "goalId":documentRef.documentID,
                      "status": status,
                      "progress": progress,
                      "sellerId": user.uid]) { (error) in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(documentRef.documentID))
                        }
        }
        
    }
    
    public func createDatabaseUser(authDataResult: AuthDataResult,
                                   completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let email = authDataResult.user.email else {
            return
        }
        db.collection(DatabaseService.usersCollection)
            .document(authDataResult.user.uid)
            .setData(["email" : email,
                      "createdDate": Timestamp(date: Date()),
                      "userId": authDataResult.user.uid]) { (error) in
                        
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(true))
                        }
        }
    }
    
    func updateDatabaseUser(displayName: String,
                            photoURL: String,
                            completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.usersCollection)
            .document(user.uid).updateData(["photoURL" : photoURL,
                                            "displayName" : displayName]) { (error) in
                                                if let error = error {
                                                    completion(.failure(error))
                                                } else {
                                                    completion(.success(true))
                                                }
        }
    }
    
    public func delete(goal: Goal,
                       completion: @escaping (Result<Bool, Error>) -> ()) {
        db.collection(DatabaseService.goalsCollection).document(goal.goalId).delete { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    
    public func fetchUserGoals(userId: String, completion: @escaping (Result<[Goal], Error>) -> ()) {
        db.collection(DatabaseService.goalsCollection).whereField("sellerId", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let goals = snapshot.documents.map { Goal($0.data()) }
                completion(.success(goals.sorted{$0.goalName > $1.goalName}))
            }
        }
    }
    
    public func addTask(goal: Goal, task: Task, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let user = Auth.auth().currentUser
//            let emailAddress = user.email
            else {
                print("missing user email address")
                return
        }
        
        let docRef = db.collection(DatabaseService.goalsCollection).document(goal.goalId).collection(DatabaseService.tasksCollection).document()
        
        db.collection(DatabaseService.goalsCollection).document(goal.goalId).collection(DatabaseService.tasksCollection).document(docRef.documentID).setData(
            ["description": task.description,
             "status": task.status]) { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
        }
    
    
}
}
