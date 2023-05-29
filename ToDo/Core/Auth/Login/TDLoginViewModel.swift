//
//  TDLoginViewModel.swift
//  ToDo
//
//  Created by Apple Macbook on 29/05/2023.
//

import Foundation
import Firebase


class TDLoginViewModel {
    
    func validateLogin(forEmail comingEmail: String,
                       password: String,
                       launchTodoApplication: @escaping (() -> Void),
                       completion: @escaping (TDError?) -> Void)  {
        var signInError: TDError?
        Auth.auth().signIn(withEmail: comingEmail, password: password) { (result, error) in
            if let err = error {
                signInError = TDError.signInFailed(err.localizedDescription)
                completion(signInError)
            } else {
                launchTodoApplication()
                completion(nil)
            }
        }
    }
    
}
