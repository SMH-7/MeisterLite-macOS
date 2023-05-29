//
//  Extensions++.swift
//  ToDo
//
//  Created by Apple Macbook on 28/05/2023.
//

import Cocoa

enum ViewAnimation {
    static func slideFromLeft(_ viewController: NSViewController, in parentViewController: NSViewController) {
        parentViewController.children.forEach { $0.removeFromParent() }
        parentViewController.view.subviews.forEach { $0.removeFromSuperview() }
        
        viewController.view.frame.origin.x = -parentViewController.view.bounds.width
        
        viewController.view.frame = CGRect(x: -parentViewController.view.bounds.width,
                                           y: 0,
                                           width: parentViewController.view.bounds.width,
                                           height: parentViewController.view.bounds.height)
    
        viewController.view.alphaValue = 0.0
        
        parentViewController.addChild(viewController)
        parentViewController.view.addSubview(viewController.view)
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.66
            viewController.view.animator().frame.origin.x = 0
            viewController.view.animator().alphaValue = 1.0
        })
    }
}

extension NSColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
