//
//  AppDelegate.swift
//  ToDo
//
//  Created by Apple Macbook on 23/05/2023.
//

import Cocoa
import FirebaseCore

@main
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        FirebaseApp.configure()
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

