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

enum GoalStatus: String {
    case complete = "complete"
    case incomplete = "incomplete"
}

class DatabaseService {
    
    static let goalsCollection = "goals"
    static let usersCollection = "users"
    static let tasksCollection = "tasks"
    
    private let db = Firestore.firestore()
    
    private init() {}
    static let shared = DatabaseService()
    
    public func createGoal(goalName: String,
                           completion: @escaping (Result<String, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        
        let documentRef = db.collection(DatabaseService.goalsCollection).document()
        
        
        db.collection(DatabaseService.goalsCollection)
            .document(documentRef.documentID)
            .setData(["goalName":goalName,
                      "imageURL": "no image url",
                      "goalId":documentRef.documentID,
                      "status": GoalStatus.incomplete.rawValue,
                      "progress": 0,
                      "userId": user.uid,
                      "createdDate": Timestamp(date: Date())]) { (error) in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(documentRef.documentID))
                        }
        }
        
    }
    
    public func addTask(goalId: String, taskDescription: String, completion: @escaping (Result<String, Error>) -> ()) {
        
        let docRef = db.collection(DatabaseService.goalsCollection).document(goalId).collection(DatabaseService.tasksCollection).document()
        
        let taskDict: [String: Any] = ["description": taskDescription,
                                       "status": false,
                                       "taskId": docRef.documentID,
                                       "createdDate": Timestamp(date: Date())]
        
        
        db.collection(DatabaseService.goalsCollection).document(goalId).collection(DatabaseService.tasksCollection).document(docRef.documentID).setData(taskDict) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(docRef.documentID))
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
}

