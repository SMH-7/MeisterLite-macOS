//
//  MenuBar.swift
//  ToDo
//
//  Created by Apple Macbook on 23/05/2023.
//

import Cocoa

class MenuBar: NSViewController {
    
    @IBOutlet weak var menuOutlineView: NSOutlineView!
    @IBOutlet weak var menuBarBackgroundView: NSView!
    
    private let viewModel = MenuBarViewModel()
    
    var delegate =  MulticastDelegate<SplitViewControllerDelegate>()
    var bgColor = NSColor(named: "TDColor2")!
    
    
    lazy var signoutButton = NSButton()
    lazy var childViewController  = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    
    override func viewWillAppear() {
        super.viewWillAppear()
        menuBarBackgroundView.wantsLayer = true
        menuBarBackgroundView.layer?.backgroundColor = NSColor(named: "FGColor")?.cgColor
    }
    
    
    private func setUpView() {
        menuOutlineView.headerView = nil

        addChild(childViewController)
        view.addSubview(childViewController.view)
        
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            childViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: menuOutlineView.topAnchor)
        ])
        

        let attributedTitle = NSAttributedString(string: "Sign Out", attributes: [NSAttributedString.Key.foregroundColor: NSColor.white])
        signoutButton.attributedTitle = attributedTitle
        signoutButton.bezelStyle = .texturedRounded
        signoutButton.target = self
        signoutButton.action = #selector(signoutButtonClicked(_:))
        view.addSubview(signoutButton)
        
        signoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            signoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
            signoutButton.heightAnchor.constraint(equalToConstant: 40),
            signoutButton.widthAnchor.constraint(equalToConstant: 60),
            
        ])
    }
    
    
    
}

extension MenuBar: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return TabViewItem.allCases.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return TabViewItem.allCases[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        return 50
    }
    
    func outlineView(_ outlineView: NSOutlineView, didAdd rowView: NSTableRowView, forRow row: Int) {
        rowView.selectionHighlightStyle = .none
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        if let outlineView = notification.object as? NSOutlineView {
            setCellBackgroudcolor(outlineView)
            delegate.invokeForEachDelegate { indDelegate in
                if let menuBarAction = indDelegate.menuBar {
                    menuBarAction(outlineView.selectedRow)
                }
            }
        }
    }
    
    func setCellBackgroudcolor(_ outlineView: NSOutlineView) {
        outlineView.enumerateAvailableRowViews { rowView, _ in
            if rowView.isSelected {
                rowView.backgroundColor = bgColor
            } else {
                rowView.backgroundColor = .clear
            }
        }
    }
}


extension MenuBar: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
        
        if let menuItem = item as? TabViewItem {
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: Constants.MenuOutlineView), owner: self) as? NSTableCellView
            if let textField = view?.textField {
                textField.stringValue = menuItem.rawValue
            }
            if let imageView = view?.imageView {
                if let image = menuItem.itemIcon {
                    let Config = NSImage.SymbolConfiguration(pointSize: 25, weight: .bold)
                    imageView.image = image.withSymbolConfiguration(Config)
                }
            }
            return view
        }
        return NSTableCellView()
    }
}

extension MenuBar {   
    @objc func signoutButtonClicked(_ sender: NSButton) {
        delegate.invokeForEachDelegate { indDelegate in
            if let signOut = indDelegate.signOut {
                signOut()
            }
        }
    }
    
}
