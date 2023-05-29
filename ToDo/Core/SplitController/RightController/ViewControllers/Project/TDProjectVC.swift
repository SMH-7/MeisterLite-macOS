//
//  TDProjectVC.swift
//  ToDo
//
//  Created by Apple Macbook on 24/05/2023.
//

import Cocoa
import RealmSwift


class TDProjectVC: NSViewController {
    
    @IBOutlet weak var projectTableView: NSTableView!
    
    private var projects : Results<Project>?
    private var senderEmail : String = ""
    
    lazy var viewModel = TDProjectViewModel()
    weak var delegate : TextFieldEditAction?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinder()
        viewModel.fetchEmail()
        fetchData()
        checkNeedForCloud()
        configView()
    }
    
    private func setBinder() {
        viewModel.email.bind {[weak self] comingMail in
            guard let self else {return}
            self.senderEmail = comingMail
        }
        viewModel.projectList.bind { [weak self] updatedList in
            guard let self else {return}
            self.projects = updatedList
            self.projectTableView.reloadData()
        }
        
        viewModel.error.bind { err in
            TDError.ViewBindingError(err)
        }
    }
    
    private func fetchData(){
        viewModel.fetchObjectsLocally(forEmail: senderEmail)
    }
    
    private func checkNeedForCloud(){
        if projects?.count == 0 {
            viewModel.fetchDataFromFirebase(forEmail: senderEmail)
        }
    }
    
    private func configView() {
        projectTableView.headerView = nil
        projectTableView.selectionHighlightStyle = .none
        
        ToDoViewController.shared.textSendingClosures.append { [weak self] caseValue, stringValue, indexValue, controllerIdentifier  in
            guard let self else { return }
            if caseValue == .projectsViewController {
                if let index = indexValue, controllerIdentifier != nil {
                    guard let previousText = self.projects?[index].ProjectTitle else { return }
                    self.viewModel.ModifyFireBaseData(forEmail: self.senderEmail, forTitle: previousText, newTitle: stringValue)
                    self.viewModel.updateObjectLocally(atIndex: index, title: stringValue)
                } else {
                    let temp = Project()
                    temp.ProjectSender = self.senderEmail
                    temp.ProjectTitle = stringValue
                    self.viewModel.uploadDataToFirebase(forEmail: self.senderEmail, Obj: temp)
                    self.viewModel.writeObjectLocally(temp)
                }
            }
        }
    }
}


extension TDProjectVC : NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return projects?.count ?? 0
        
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return projects?[row]
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(Constants.ProjectTableViewCell), owner: nil) as? NSTableCellView {
            cellView.textField?.stringValue = projects![row].ProjectTitle
            cellView.textField?.textColor = .white
            return cellView
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        guard let detachedObj = RealmHelper.DetachedCopy(of: projects![row]) else { return []}
        
        if edge == .trailing {
            let deleteAction = NSTableViewRowAction(style: .destructive, title: "Delete", handler: { (rowAction, row) in
                self.viewModel.ModifyFireBaseData(forEmail: self.senderEmail,
                                                  forTitle: detachedObj.ProjectTitle,
                                                  toDel: true)
                self.viewModel.deleteObjectLocally(atIndex: row)
                tableView.removeRows(at: IndexSet(integer: row), withAnimation: .effectFade)
            })
            deleteAction.backgroundColor = NSColor.systemRed
            
            let editAction = NSTableViewRowAction(style: .regular, title: "Edit", handler: { (rowAction, row) in
                self.delegate?.editTextField(atIndex: row, withText: self.projects![row].ProjectTitle, fromController: .projectsViewController)
            })
            editAction.backgroundColor = NSColor.systemGreen
            
            return [editAction, deleteAction]
        }
        return []
    }
    
}
