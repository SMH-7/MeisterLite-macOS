//
//  AddTextFieldContainer.swift
//  ToDo
//
//  Created by Apple Macbook on 28/05/2023.
//

import AppKit

class AddTextFieldContainer: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
    
    private func config() {
        wantsLayer = true
        layer?.backgroundColor = NSColor(named: "BGColor")?.cgColor
        layer?.cornerRadius = 2.5
        isHidden = true
    }
}
