//
//  TDWelcomeVC.swift
//  ToDo
//
//  Created by Apple Macbook on 24/05/2023.
//

import Cocoa

class TDWelcomeVC: NSViewController {
    
    lazy var welcomeLabel: WelcomeTextField = {
        let label = WelcomeTextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.stringValue = "Welcome"
        label.font = NSFont.boldSystemFont(ofSize: 24)
        label.textColor = NSColor.systemCyan
        return label
    }()
    
    lazy var quoteLabel: WelcomeTextField = {
        let label = WelcomeTextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = NSFont.systemFont(ofSize: 14)
        label.textColor = NSColor.labelColor
        return label
    }()
    
    let quotes: [String] = DB.Quotes

    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.clear.cgColor
        
        loadRandomQuote()

        view.addSubview(welcomeLabel)
        view.addSubview(quoteLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 100),
            welcomeLabel.widthAnchor.constraint(equalToConstant: 150),
            
            quoteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quoteLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            quoteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            quoteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func loadRandomQuote() {
        quoteLabel.stringValue =  quotes[Int.random(in: 0..<quotes.count)]
    }
}
