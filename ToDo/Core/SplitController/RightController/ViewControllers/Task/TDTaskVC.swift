//
//  TDTaskVC.swift
//  ToDo
//
//  Created by Apple Macbook on 24/05/2023.
//

import Cocoa
import RealmSwift

class TDTaskVC: NSViewController {

    @IBOutlet weak var taskTableView: NSTableView!
    
    lazy var viewModel = TDTaskViewModel()
    weak var delegate : TextFieldEditAction?
    
    
    private var tasks : Results<Task>?
    private var senderEmail : String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinder()
        viewModel.fetchEmail()
        fetchData()
        checkNeedForCloud()
        setUpViews()
    }
    
    
    private func setBinder() {
        viewModel.email.bind {[weak self] comingMail in
            guard let self else {return}
            self.senderEmail = comingMail
        }
        viewModel.taskList.bind { [weak self] updatedList in
            guard let self else {return}
            self.tasks = updatedList
            self.taskTableView.reloadData()
        }
        
        viewModel.error.bind { err in
            TDError.ViewBindingError(err)
        }
    }
    
    private func fetchData(){
        viewModel.fetchObjectsLocally(forEmail: senderEmail)
    }
    
    private func checkNeedForCloud(){
        if tasks?.count == 0 {
            viewModel.fetchDataFromFirebase(forEmail: senderEmail)
        }
    }
    
    private func setUpViews() {
        taskTableView.headerView = nil
        taskTableView.selectionHighlightStyle = .none
        
        ToDoViewController.shared.textSendingClosures.append { [weak self] caseValue, stringValue, indexValue, controllerIdentifier  in
            guard let self else { return }
            if caseValue == .tasksViewController {
                if let index = indexValue, controllerIdentifier != nil {
                    guard let previousText = self.tasks?[index].TaskTitle else { return }
                    self.viewModel.ModifyFireBaseData(forEmail: self.senderEmail, forTitle: previousText, newTitle: stringValue)
                    self.viewModel.updateObjectLocally(atIndex: index, title: stringValue)
                } else {
                    let temp = Task()
                    temp.TaskSender = self.senderEmail
                    temp.TaskTitle = stringValue
                    self.viewModel.uploadDataToFirebase(forEmail: self.senderEmail, Obj: temp)
                    self.viewModel.writeObjectLocally(temp)
                }
            }
        }
    }
    
}

extension TDTaskVC : NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tasks?.count ?? 0
        
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return tasks?[row]
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(Constants.TaskTableViewCell), owner: nil) as? NSTableCellView {
            cellView.textField?.stringValue = tasks![row].TaskTitle
            cellView.textField?.textColor = .white
            return cellView
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        guard let detachedObj = RealmHelper.DetachedCopy(of: tasks![row]) else { return []}

        if edge == .trailing {
            let deleteAction = NSTableViewRowAction(style: .destructive, title: "Delete", handler: { (rowAction, row) in
                self.viewModel.ModifyFireBaseData(forEmail: self.senderEmail,
                                                  forTitle: detachedObj.TaskTitle,
                                                  toDel: true)
                self.viewModel.deleteObjectLocally(atIndex: row)
                tableView.removeRows(at: IndexSet(integer: row), withAnimation: .effectFade)
            })
            deleteAction.backgroundColor = NSColor.systemRed
            
            let editAction = NSTableViewRowAction(style: .regular, title: "Edit", handler: { (rowAction, row) in
                self.delegate?.editTextField(atIndex: row, withText: self.tasks![row].TaskTitle, fromController: .tasksViewController)

            })
            editAction.backgroundColor = NSColor.systemGreen
            
            return [editAction, deleteAction]
        }
        return []
    }

}
