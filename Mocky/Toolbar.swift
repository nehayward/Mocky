//
//  ToolBar.swift
//  Mocky
//
//  Created by Nick Hayward on 6/20/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Cocoa
import Foundation

class Toolbar: NSWindowController {
    
    let ios13DeviceKey = "com.apple.CoreSimulator.SimRuntime.iOS-13-0"
    
    @IBOutlet weak var ServerState: NSButton!
    
    @IBOutlet weak var Port: NSTextField!
    
    @IBOutlet weak var SimulatorList: NSPopUpButton!
    
    var devices: [Device] = []
    
    override func loadWindow() {
        NotificationCenter.default.addObserver(self, selector: #selector(startServer), name: .StartServer, object: nil)
    }
    
    @IBAction func ServerButton(_ button: NSButton) {
        if button.state == .off {
            ServerState.title = "Start Server"
            NotificationCenter.default.post(name: .StopServer, object: nil)
            
            return
        }
        
        ServerState.title = "Stop Server"
        NotificationCenter.default.post(name: .StartServer, object: Port.stringValue)
    }
    
    @IBAction func generateSimulator(_ sender: Any) {
        let task = Process()
        let scriptURL = Bundle.main.url(forResource: "generateSimulator", withExtension: ".sh")!
        
        
        task.arguments = ["Nick","com.apple.CoreSimulator.SimDeviceType.iPad-Pro--10-5-inch-"]
        task.executableURL = scriptURL
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        task.launch()
        
        
    }
    
    override func windowDidLoad() {
        //        let task = Process()
        //        let scriptURL = Bundle.main.url(forResource: "simulatorList", withExtension: ".sh")!
        //
        //        task.executableURL = scriptURL
        //
        //        let pipe = Pipe()
        //        task.standardOutput = pipe
        //
        //        task.launch()
        //
        //
        //        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        //        //        let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        //
        //        let empty = try JSONDecoder().decode(Empty.self, from: data)
        //
        //        devices = empty.devices[ios13DeviceKey]!
        //        for device in empty.devices[ios13DeviceKey]!  {
        //            print(device.name)
        //            SimulatorList.addItem(withTitle: device.name)
        //        }
    }
    
    @objc func startServer(){
        ServerState.state = .on
        ServerState.title = "Stop Server"
    }
}

extension Toolbar: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        
        if let textField = obj.object as? NSTextField, self.Port.identifier == textField.identifier && Port.stringValue.count == 4 {
            
            print(Port.stringValue)
        }
    }
}
