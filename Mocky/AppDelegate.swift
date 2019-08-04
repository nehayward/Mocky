//
//  AppDelegate.swift
//  Mocky
//
//  Created by Nick Hayward on 6/13/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var preferencesWindowController: NSWindowController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            sender.windows.forEach { $0.makeKeyAndOrderFront(self) }
        }
        
        return true
    }
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        
        loadRoutes(from: URL(fileURLWithPath: filename))

        return true
    }
}
