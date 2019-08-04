//
//  PreferencesViewController.swift
//  Magic Mirror
//
//  Created by Nick Hayward on 6/27/18.
//  Copyright © 2018 Nick Hayward. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        self.parent?.view.window?.title = self.title!
    }
    
    @IBAction func downloadCerts(_ sender: Any) {
         let caCertificateURL = Bundle.main.url(forResource: "ca-crt", withExtension: "der")!
    
        let data = try! Data(contentsOf: caCertificateURL)
        
        let downloadsURL = try! FileManager.default.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        try! data.write(to: downloadsURL.appendingPathComponent("ca-crt.der"))
    }
}
