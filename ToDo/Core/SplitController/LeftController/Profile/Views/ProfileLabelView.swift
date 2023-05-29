//
//  ProfileLabelView.swift
//  ToDo
//
//  Created by Apple Macbook on 28/05/2023.
//

import AppKit

class ProfileLabelView: NSTextField {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
    
    private func config() {
        self.isEditable = false
        self.isBordered = false
        self.textColor = .white
        self.alignment = .center
        self.backgroundColor = NSColor.clear
    }
}
