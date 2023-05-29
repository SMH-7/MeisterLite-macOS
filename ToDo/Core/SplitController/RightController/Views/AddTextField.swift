//
//  AddTextField.swift
//  ToDo
//
//  Created by Apple Macbook on 28/05/2023.
//

import AppKit

class AddTextField: NSTextField {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
    
    private func config() {
        self.backgroundColor = NSColor(named: "FGColor")?.withAlphaComponent(0.1)
        self.layer?.cornerRadius = 2.5
        self.focusRingType = .none
        self.textColor = NSColor.white
    }
}

