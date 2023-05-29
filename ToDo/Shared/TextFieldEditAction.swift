//
//  TextFieldEditAction.swift
//  ToDo
//
//  Created by Apple Macbook on 28/05/2023.
//

import Cocoa

protocol TextFieldEditAction : AnyObject {
    func editTextField(atIndex index: Int, withText text: String, fromController controller: SelectedViewController)
}
