//
//  TDAuthViewModel.swift
//  ToDo
//
//  Created by Apple Macbook on 28/05/2023.
//

import Cocoa

class TDAuthViewModel {
    
    
    func presentViewController(_ viewController: NSViewController, _ parentController: NSViewController) {
        ViewAnimation.slideFromLeft(viewController, in: parentController)
    }
}

