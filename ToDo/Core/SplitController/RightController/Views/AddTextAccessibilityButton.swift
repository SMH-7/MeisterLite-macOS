//
//  AddTextAccessibilityButton.swift
//  ToDo
//
//  Created by Apple Macbook on 28/05/2023.
//

import AppKit

class AddTextAccessibilityButton: NSButton {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
    
    private func config() {
        self.image = NSImage(systemSymbolName: "plus", accessibilityDescription: nil)
        self.image?.isTemplate = true
        self.contentTintColor = NSColor.white
        self.imageScaling = .scaleProportionallyDown
        self.bezelStyle = .texturedRounded
        self.isBordered = false
    }
}
