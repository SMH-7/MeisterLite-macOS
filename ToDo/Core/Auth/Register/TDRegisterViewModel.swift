//
//  TDRegisterViewModel.swift
//  ToDo
//
//  Created by Apple Macbook on 29/05/2023.
//

import Foundation
import Firebase

class TDRegisterViewModel {
    
    func createUser(email: String,
                    password: String,
                    launchTodoApplication: @escaping (() -> Void),
                    completion: @escaping (TDError?) -> Void) {
        var signInError: TDError?
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let err = error {
                signInError = TDError.registerationFailed(err.localizedDescription)
                completion(signInError)
            }else {
                launchTodoApplication()
                completion(nil)
            }
        }
    }
    
}

