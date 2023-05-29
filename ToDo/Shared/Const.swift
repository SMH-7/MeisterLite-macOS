//
//  Const.swift
//  ToDo
//
//  Created by Apple Macbook on 23/05/2023.
//

import Cocoa

enum Constants {
    static let MenuOutlineView = "MenuCell"
    static let ProjectTableViewCell = "ProjectCellView"
    static let TaskTableViewCell = "TaskCellView"
    static let ChecklistTableViewCell = "ChecklistCellView"
    
}
enum TabViewItem: String, CaseIterable {
    
    case Main = "Main"
    case Projects = "Projects"
    case Tasks = "Tasks"
    case Checklists = "Checklists"
    
    
    var itemIcon: NSImage? {
        switch self {
        case .Main: return NSImage(systemSymbolName: "house", accessibilityDescription: nil)
        case .Projects: return NSImage(systemSymbolName: "list.bullet", accessibilityDescription: nil)
        case .Tasks: return NSImage(systemSymbolName: "rectangle.and.pencil.and.ellipsis", accessibilityDescription: nil)
        case .Checklists: return NSImage(systemSymbolName: "checklist", accessibilityDescription: nil)
        }
    }
}

enum SelectedViewController: Int {
    case mainViewController = 0, projectsViewController, tasksViewController, checklistViewController
}
enum Category {
    case checkList, taskList, projectList, profile
}

enum FireBaseConstant {
    static let projectTable = "Projects"
    static let taskTable = "Tasks"
    static let checklistTable = "CheckLists"
    static let InfoCollectionName =  "Info"
    
    enum Project {
        static let title = "Project"
        static let sender = "Sender"
        static let time = "Date"
    }
    enum Task {
        static let title = "Task"
        static let sender  = "Sender"
        static let time = "Date"
    }
    enum Checklist {
        static let title = "CheckList"
        static let sender  = "Sender"
        static let time = "Date"
        static let check = "Condition"
    }
    enum User {
        static let cover = "Background"
        static let profile = "Profile"
        static let email = "Sender"
    }
}

enum imagePicker {
    case profile, cover
}
