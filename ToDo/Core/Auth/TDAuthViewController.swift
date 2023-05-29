//
//  TDAuthViewController.swift
//  ToDo
//
//  Created by Apple Macbook on 27/05/2023.
//

import Cocoa

class TDAuthViewController: NSViewController {

    
    @IBOutlet weak var authView: NSView!

    var viewModel = TDAuthViewModel()
    
    override func viewWillAppear() {
        super.viewWillAppear()
        setBackground()
    }
    
    private func setBackground() {
        authView.wantsLayer = true
        authView.layer?.backgroundColor = NSColor(named: "BGColor")?.cgColor
    }
}

extension TDAuthViewController {
    
    @IBAction func launchLoginView(_ sender: NSButton) {
        if let loginViewController = self.storyboard?.instantiateController(withIdentifier: "TDLoginViewController") as? TDLoginViewController {
            viewModel.presentViewController(loginViewController, self)
        }
    }
    
    @IBAction func launchRegisterView(_ sender: Any) {
        if let registerViewController = self.storyboard?.instantiateController(withIdentifier: "TDRegisterViewController") as? TDRegisterViewController {
            viewModel.presentViewController(registerViewController, self)
        }
    }
}
