//
//  ProfilePhotoImageView.swift
//  ToDo
//
//  Created by Apple Macbook on 28/05/2023.
//

import Cocoa

class ProfilePhotoImageView: NSImageView {
    override func draw(_ dirtyRect: NSRect) {
        if let image = self.image {
            let frameRect = NSRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            let imageRect = NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            
            let scalingFactor = max(frameRect.size.width / imageRect.size.width, frameRect.size.height / imageRect.size.height)
            
            let scaledImageRect = NSRect(x: 0, y: 0, width: imageRect.size.width * scalingFactor, height: imageRect.size.height * scalingFactor)
            let centeredImageRect = NSRect(
                x: (frameRect.size.width - scaledImageRect.size.width) / 2.0,
                y: (frameRect.size.height - scaledImageRect.size.height) / 2.0,
                width: scaledImageRect.size.width,
                height: scaledImageRect.size.height
            )
            
            image.draw(in: centeredImageRect, from: imageRect, operation: .sourceOver, fraction: 1.0) 
        }
    }
}
