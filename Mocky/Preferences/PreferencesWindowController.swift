//
//  PreferencesWindowController.swift
//  Magic Mirror
//
//  Created by Nick Hayward on 6/27/18.
//  Copyright © 2018 Nick Hayward. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController, NSWindowDelegate {
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }
  
  func windowShouldClose(_ sender: NSWindow) -> Bool {
    self.window?.orderOut(sender)
    return false
  }
}
