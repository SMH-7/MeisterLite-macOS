//
//  TDChecklistVC.swift
//  ToDo
//
//  Created by Apple Macbook on 24/05/2023.
//

import Cocoa
import RealmSwift

class TDChecklistVC: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var checklistTableView: NSTableView!
    lazy var viewModel = TDChecklistViewModel()
    
    weak var delegate : TextFieldEditAction?

    var checklists : Results<Checklist>?
    private var senderEmail : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinder()
        viewModel.fetchEmail()
        fetchData()
        checkNeedForCloud()
        setUpView()
    }
    
    private func setBinder() {
        viewModel.email.bind {[weak self] comingMail in
            guard let self else {return}
            self.senderEmail = comingMail
        }
        viewModel.checklists.bind({ [weak self] updateList in
            guard let self else { return }
            self.checklists = updateList
            self.checklistTableView.reloadData()
        })
        viewModel.error.bind { err in
            TDError.ViewBindingError(err)
        }
    }
    
    private func fetchData(){
        viewModel.fetchObjectsLocally(forEmail: senderEmail)
    }
    
    private func checkNeedForCloud(){
        if checklists?.count == 0 {
            viewModel.fetchDataFromFirebase(forEmail: senderEmail)
        }
    }
    
    private func setUpView() {
        checklistTableView.headerView = nil
        checklistTableView.selectionHighlightStyle = .none
        checklistTableView.action = #selector(didSelectRow)
        
        ToDoViewController.shared.textSendingClosures.append { [weak self] caseValue, stringValue, indexValue, controllerIdentifier  in
            guard let self else { return }
            if caseValue == .checklistViewController {
                if let index = indexValue, controllerIdentifier != nil {
                    guard let previousTitle = self.checklists?[index].CheckListTitle else { return }
                    self.viewModel.ModifyFireBaseData(forEmail: self.senderEmail, forTitle: previousTitle, newTitle: stringValue)
                    self.viewModel.updateObjectLocally(atIndex: index, title: stringValue)
                } else {
                    let temp = Checklist()
                    temp.CheckListTitle = stringValue
                    temp.CheckListSender = self.senderEmail
                    self.viewModel.uploadDataToFirebase(forEmail: self.senderEmail, Obj: temp)
                    self.viewModel.writeObjectLocally(temp)
                }
            }
        }
    }
    
}

extension TDChecklistVC {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return checklists?.count ?? 0
        
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return checklists?[row]
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(Constants.ChecklistTableViewCell), owner: nil) as? NSTableCellView {
            cellView.textField?.stringValue = checklists![row].CheckListTitle
            cellView.textField?.textColor = .white
            
            cellView.imageView?.image = NSImage(systemSymbolName: "checkmark", accessibilityDescription: nil)
            cellView.imageView?.isHidden = checklists![row].Check ? false : true
            return cellView
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        guard let detachedObj = RealmHelper.DetachedCopy(of: checklists![row]) else { return [] }
        if edge == .trailing {
            let deleteAction = NSTableViewRowAction(style: .destructive, title: "Delete", handler: { (rowAction, row) in
                self.viewModel.ModifyFireBaseData(forEmail: detachedObj.CheckListSender, forTitle: detachedObj.CheckListTitle, toDel : true)
                self.viewModel.deleteObjectLocally(atIndex: row)
                tableView.removeRows(at: IndexSet(integer: row), withAnimation: .effectFade)
            })
            deleteAction.backgroundColor = NSColor.systemRed
            
            let editAction = NSTableViewRowAction(style: .regular, title: "Edit", handler: { (rowAction, row) in
                self.delegate?.editTextField(atIndex: row, withText: self.checklists![row].CheckListTitle, fromController: .checklistViewController)
            })
            editAction.backgroundColor = NSColor.systemGreen
            
            return [editAction, deleteAction]
        }
        return []
    }

    @objc private func didSelectRow() {
        let selectedRow = checklistTableView.selectedRow
        guard selectedRow >= 0 && selectedRow < checklistTableView.numberOfRows else {
            return
        }
        
        if var checklists {
            viewModel.ModifyFireBaseData(forEmail: senderEmail, forTitle: checklists[selectedRow].CheckListTitle, newCheck: checklists[selectedRow].Check)
            viewModel.updateLocally(atIndex: selectedRow)
        }
    }
    
}
