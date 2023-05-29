//
//  WelcomeTextField.swift
//  ToDo
//
//  Created by Apple Macbook on 28/05/2023.
//

import Cocoa

class WelcomeTextField : NSTextField {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
    
    private func config() {
        isBezeled = false
        isEditable = false
        isSelectable = false
        backgroundColor = NSColor.clear
    }
}
