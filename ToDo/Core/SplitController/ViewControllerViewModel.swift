//
//  ViewControllerViewModel.swift
//  ToDo
//
//  Created by Apple Macbook on 28/05/2023.
//

import Cocoa

class ViewControllerViewModel {
    
    
    
    func relaunch(_ viewController: NSViewController, in parentViewController: NSSplitViewController) {

        parentViewController.removeFromParent()
        parentViewController.view.removeFromSuperview()

        let newParentViewController = NSViewController()
        newParentViewController.view = NSView(frame: parentViewController.view.frame)

        viewController.view.frame = newParentViewController.view.frame
        newParentViewController.addChild(viewController)
        newParentViewController.view.addSubview(viewController.view)

        let window = NSWindow(contentViewController: newParentViewController)
        NSApp.mainWindow?.setFrame(window.frame, display: true)
        NSApp.mainWindow?.contentViewController = window.contentViewController

        parentViewController.splitViewItems.removeAll()
        parentViewController.view.layoutSubtreeIfNeeded()
    }
}
