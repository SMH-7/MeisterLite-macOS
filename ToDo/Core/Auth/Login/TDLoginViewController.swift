//
//  TDLoginViewController.swift
//  ToDo
//
//  Created by Apple Macbook on 27/05/2023.
//

import Cocoa

class TDLoginViewController: NSViewController, TodoApplicationLauncher {

    private let viewModel = TDLoginViewModel()
    
    @IBOutlet weak var loginTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func launchMainView(_ sender: NSButton) {
        viewModel.validateLogin(forEmail: loginTextField.stringValue,
                      password: passwordTextField.stringValue, launchTodoApplication: {[weak self] in
            self?.launchTodoApplication()
        }, completion: { error in
            if let err = error {
                print(err)
            }
        })
    }
}
