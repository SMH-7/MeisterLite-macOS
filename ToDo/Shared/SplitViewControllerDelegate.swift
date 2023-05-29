//
//  SplitViewControllerDelegate.swift
//  ToDo
//
//  Created by Apple Macbook on 28/05/2023.
//

import Foundation

@objc protocol SplitViewControllerDelegate: AnyObject {
    @objc optional func menuBar(_ selectedRow: Int)
    @objc optional func signOut()
}
