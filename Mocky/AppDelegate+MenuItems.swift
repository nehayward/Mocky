//
//  MenuItems.swift
//  Mocky
//
//  Created by Nick Hayward on 8/4/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Foundation
import Cocoa

extension AppDelegate {
    
    @IBAction func formatJSON(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("Format.Detail.View"), object: nil)
    }
    
    @IBAction func openRoutes(_ sender: Any) {
        let dialog = NSOpenPanel()
        dialog.showsResizeIndicator    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["json"];
        
        if (dialog.runModal() == .OK) {
            guard let file = dialog.url else { return }
            loadRoutes(from: file)
        }
    }
    
    
    @IBAction func saveRoutes(_ sender: Any) {
        NotificationCenter.default.post(name: .SaveRoutes, object: nil, userInfo: nil)
    }
    
    @IBAction func startServer(_ sender: Any){
        NotificationCenter.default.post(name: .StartServer, object: nil)
    }
    
    @IBAction func preferences(_ sender: Any){
        if !(preferencesWindowController != nil) {
            let storyboard = NSStoryboard(name: "Preferences", bundle: nil)
            preferencesWindowController = storyboard.instantiateInitialController() as? NSWindowController
        }
        
        if (preferencesWindowController != nil) {
            preferencesWindowController?.showWindow(sender)
        }
    }
    
    func loadRoutes(from url: URL){
        do {
            let data = try Data(contentsOf: url, options: .uncached)
            
            let routes = try JSONDecoder().decode([Route].self, from: data)
            
            let routesDict:[String: [Route]] = ["routes": routes]
            
            NotificationCenter.default.post(name: .UpdateRoutes, object: nil, userInfo: routesDict)
        } catch {
//            let alert = NSAlert()
            
        }
    }
    
    @IBAction func newRoute(_ sender: Any){
        NotificationCenter.default.post(name: .NewRoute, object: nil)
    }
}
