//
//  AuthenticationSession.swift
//  Hijack
//
//  Created by Chelsi Christmas on 5/23/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthenticationSession {
    public func createNewUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
        // Firebase handles the encryption of the password
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let authDataResult = authDataResult {
                completion(.success(authDataResult))
            }
        }
    }
    
    public func signInExistingUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let authDataResult = authDataResult {
                completion(.success(authDataResult))
            }
        }
    }
    
}
