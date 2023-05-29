//
//  TodoApplicationLauncher.swift
//  ToDo
//
//  Created by Apple Macbook on 28/05/2023.
//

import Cocoa

protocol TodoApplicationLauncher {
    func launchTodoApplication()
}

extension TodoApplicationLauncher where Self: NSViewController {
    func launchTodoApplication() {
        if let mainApplication = storyboard?.instantiateController(withIdentifier: "ViewController") as? ViewController {
            ViewAnimation.slideFromLeft(mainApplication, in: self)
        }
    }
}
