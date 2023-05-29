//
//  ToDoViewController.swift
//  ToDo
//
//  Created by Apple Macbook on 23/05/2023.
//

import Cocoa

class ToDoViewController: NSViewController {
    
    static let shared = ToDoViewController()
    
    lazy var welcomeViewController = TDWelcomeVC()
    lazy var projectViewController = TDProjectVC()
    lazy var taskViewController = TDTaskVC()
    lazy var checklistViewController = TDChecklistVC()
    
    lazy var viewControllers: [NSViewController] = {
        return [welcomeViewController, projectViewController, taskViewController, checklistViewController]
    }()
    
    lazy var addText: AddTextField = {
        let textField = AddTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    
    lazy var addTextAccessibilityButton: AddTextAccessibilityButton = {
        let button = AddTextAccessibilityButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var bottomAddTextView: AddTextFieldContainer = {
        let view = AddTextFieldContainer()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var contentController: NSViewController? {
        willSet {
            contentController?.removeFromParent()
            contentController?.view.removeFromSuperview()
        }
        didSet {
            if let newContentController = contentController {
                addChild(newContentController)
                view.addSubview(newContentController.view)
                
                newContentController.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    newContentController.view.topAnchor.constraint(equalTo: view.topAnchor),
                    newContentController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    newContentController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    newContentController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.85)
                ])
            }
        }
    }

    
    
    typealias TextSendingClosure = (_ sourceController: SelectedViewController?,
                                    _ stringValue: String,
                                    _ rowValue: Int?,
                                    _ destinationController: SelectedViewController?) -> Void

    var textSendingClosures: [TextSendingClosure?] = []
    
    var onCurrentSelectedControllerDidChange: ((SelectedViewController) -> Void)?
    var currentSelectedController: SelectedViewController = .mainViewController {
        didSet {
            onCurrentSelectedControllerDidChange?(currentSelectedController)
        }
    }
    
    var tempIndex : Int = -1
    var tempText : String? = nil
    var tempControllerReference : SelectedViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        guard let backgroundImage = NSImage(named: "PGWelcome") else {
            fatalError("Image not available")
        }
        view.wantsLayer = true
        view.layer?.contents = backgroundImage
        
        contentController = viewControllers[0]
        projectViewController.delegate = self
        taskViewController.delegate = self
        checklistViewController.delegate = self
        
        view.addSubview(bottomAddTextView)
        bottomAddTextView.addSubview(addText)
        bottomAddTextView.addSubview(addTextAccessibilityButton)
        
        NSLayoutConstraint.activate([
            bottomAddTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomAddTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomAddTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            bottomAddTextView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            addText.leadingAnchor.constraint(equalTo: bottomAddTextView.leadingAnchor, constant: 40),
            addText.trailingAnchor.constraint(equalTo: bottomAddTextView.trailingAnchor, constant: -10),
            addText.heightAnchor.constraint(equalToConstant: 40),
            addText.centerYAnchor.constraint(equalTo: bottomAddTextView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addTextAccessibilityButton.leadingAnchor.constraint(equalTo: bottomAddTextView.leadingAnchor),
            addTextAccessibilityButton.centerYAnchor.constraint(equalTo: bottomAddTextView.centerYAnchor),
            addTextAccessibilityButton.widthAnchor.constraint(equalToConstant: 40),
            addTextAccessibilityButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        onCurrentSelectedControllerDidChange = { [weak self] newValue in
            self?.bottomAddTextView.isHidden = newValue == .mainViewController ? true : false
        }
    }
    
    
}

extension ToDoViewController : SplitViewControllerDelegate {
    func menuBar(_ selectedRow: Int) {
        if selectedRow >= 0 && selectedRow < viewControllers.count {
            contentController = viewControllers[selectedRow]
            currentSelectedController = SelectedViewController(rawValue: selectedRow)!
            tempControllerReference = nil
            addText.stringValue = ""
        } else {
            NSLog("Invalid row")
        }
    }
}

extension ToDoViewController : NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
            if control == addText {
                for closure in ToDoViewController.shared.textSendingClosures {
                    if let closure =  closure {
                        if tempControllerReference != nil {
                            closure(currentSelectedController, addText.stringValue, tempIndex, tempControllerReference)
                        } else {
                            closure(currentSelectedController, addText.stringValue, nil, nil)
                        }
                    }
                }
                self.tempControllerReference = nil
            }
            return true
        }
        return false
    }
}

extension ToDoViewController : TextFieldEditAction {
    func editTextField(atIndex index: Int, withText text: String, fromController controller: SelectedViewController) {
        (tempText, addText.stringValue) = (text,text)
        tempIndex = index
        tempControllerReference = controller
    }
}
