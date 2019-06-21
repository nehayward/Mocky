//
//  ViewController.swift
//  Mocky
//
//  Created by Nick Hayward on 6/13/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Cocoa
import Telegraph

class ViewController: NSViewController {

    let mockServer = TelegraphStub()
    @IBOutlet weak var endpoint: NSTextField!
    @IBOutlet weak var method: NSPopUpButton!
    @IBOutlet weak var statusCode: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func startStopServer(_ sender: NSButton) {
        if sender.state == .on {
            sender.title = "Stop Server"
            mockServer.setUp()
            return
        }
        
        sender.title = "Start Server"
        
        mockServer.tearDown()
    }
    
    @IBAction func loadFile(_ sender: Any) {
        let dialog = NSOpenPanel()
        var httpMethod: HTTPMethod = .GET
        var httpCode: Int = 200
        
        switch method.selectedItem?.title {
        case "GET":
            httpMethod = .GET
        case "POST":
            httpMethod = .POST
        case "PUT":
            httpMethod = .PUT
        case "DELETE":
            httpMethod = .DELETE
        case .none: break
            
        case .some(_): break
            
        }
        
        dialog.title                   = "Choose a .json file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["json"];
        
        if statusCode.stringValue != "" {
            httpCode = Int(statusCode.stringValue) ?? 200
        }
        
        
        if (dialog.runModal() == .OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                mockServer.server?.route(httpMethod, endpoint.stringValue, response: { () -> HTTPResponse in
                    let data = try! Data(contentsOf: result!, options: .uncached)
                    let httpStatus = HTTPStatus(code: httpCode, phrase: "")
                    let httpVersion = HTTPVersion(major: 1, minor: 0)
                    let httpHeaders = HTTPHeaders()
                    let response = HTTPResponse(httpStatus, version: httpVersion, headers: httpHeaders, body: data)
                    
                    return response
                })
                
            }
        } else {
            // User clicked on "Cancel"
            return
        }
        
    }
}

