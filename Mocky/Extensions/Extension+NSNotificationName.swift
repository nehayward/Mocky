//
//  File.swift
//  Mocky
//
//  Created by Nick Hayward on 7/9/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let StartServer = NSNotification.Name("Mocky.StartServer")
    static let StopServer = NSNotification.Name("Mocky.StopServer")
    static let RestartServer = NSNotification.Name("Mocky.RestartServer")
    
    static let UpdateRoutes = NSNotification.Name("Mocky.UpdateRoutes")
    static let SaveRoutes = NSNotification.Name("Mocky.SaveRoutes")
    static let NewRoute = NSNotification.Name("Mocky.NewRoute")

    
    static let AppleInterfaceThemeChangedNotification = Notification.Name("AppleInterfaceThemeChangedNotification")
}
