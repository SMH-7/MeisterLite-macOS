//
//  TDRegisterViewController.swift
//  ToDo
//
//  Created by Apple Macbook on 27/05/2023.
//

import Cocoa

class TDRegisterViewController: NSViewController, TodoApplicationLauncher {

    private let viewModel =  TDRegisterViewModel()
    
    @IBOutlet weak var registerPassword: NSSecureTextField!
    @IBOutlet weak var registerEmail: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func launchMainView(_ sender: NSButton) {
        viewModel.createUser(email: registerEmail.stringValue,
                             password: registerPassword.stringValue) {[weak self] in
            self?.launchTodoApplication()
        } completion: { error in
            if let err = error {
                print(err)
            }
        }
    }
}
