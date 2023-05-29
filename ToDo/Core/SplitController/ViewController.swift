//
//  ViewController.swift
//  ToDo
//
//  Created by Apple Macbook on 23/05/2023.
//

import Cocoa

class ViewController: NSSplitViewController {

    var viewModel = ViewControllerViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        configDelegates()
    }
    
    private func configDelegates() {
        guard let menuBarItem = self.splitViewItems[0].viewController as? MenuBar ,
              let contentViewController = self.splitViewItems[1].viewController as? ToDoViewController else { return }
        menuBarItem.delegate.add(delegate: contentViewController)
        menuBarItem.delegate.add(delegate: self)
    }
}

extension ViewController : SplitViewControllerDelegate {
    func signOut() {
        if let relaunchToAuth = self.storyboard?.instantiateController(withIdentifier: "TDAuthViewController") as? TDAuthViewController {
            viewModel.relaunch(relaunchToAuth, in: self)
        }
    }
}
