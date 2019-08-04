//
//  RouteDetailViewController.swift
//  Mocky
//
//  Created by Nick Hayward on 6/21/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Cocoa

protocol RouteDetailViewControllerDelegate {
    func updatedRoute(route: Route, index: Int)
}

class RouteDetailViewController: NSViewController, RoutesTableViewControllerDelegate {
    
    var route: Route? {
        didSet {
            view.isHidden = false
            guard let route = route else { return }
            delegate?.updatedRoute(route: route, index: index)
        }
    }
    
    var index = 0
    var delegate: RouteDetailViewControllerDelegate?
    
    @IBOutlet var textView: NSTextView!
    
    @IBOutlet weak var path: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var methodButton: NSPopUpButton!
    @IBOutlet weak var statusCode: NSTextField!
    @IBOutlet weak var delayButton: NSPopUpButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print("RoutesDetail")
        textView.delegate = self
        textView.isAutomaticTextCompletionEnabled = false
        //        textView.backgroundColor = .white
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        
        //        window?.minSize = NSSize(width: 410, height: 600 )
        //        window?.manSize = NSSize(width: 600, height: 1200 )
        
        NotificationCenter.default.addObserver(self, selector: #selector(formatText), name: Notification.Name(rawValue: "Format.Detail.View"), object: nil)
        
        saveButton.isHidden = true
        
        path.delegate = self
        statusCode.delegate = self
        
        if route == nil {
            view.isHidden = true
        }
    }
    
    @objc private func formatText(){
        guard let formattedString = textView.string.data(using: .utf8)?.prettyPrintedJSONString else { return }
        textView.string = formattedString
        formatTextInTextView(textView: textView)
    }
    
    func updateView(for route: Route, at index: Int) {
        self.index = index
        self.route = route
        
        guard let json = route.response.data(using: .utf8)?.prettyPrintedJSONString else {
            return
        }
        
        textView.string = json
        
        formatTextInTextView(textView: textView)
        
        path.stringValue = route.path
        
        switch route.method {
        case .GET:
            methodButton.selectItem(at: 0)
        case .POST:
            methodButton.selectItem(at: 1)
        case .PUT:
            methodButton.selectItem(at: 2)
        case .DELETE:
            methodButton.selectItem(at: 3)
        }
        
        statusCode.stringValue = String(route.statusCode.rawValue)
        delayButton.selectItem(at: route.delay)
    }
    
    @IBAction func saveFile(_ sender: Any) {
        formatText()
        route?.response = textView.string
    }
    
    @IBAction func delay(_ sender: Any) {
        let sender = sender as! NSPopUpButton
        route?.delay = sender.indexOfSelectedItem
    }
    
    @IBAction func routeMethodChanged(_ sender: Any) {
        let sender = sender as! NSButton
        
        route?.method = Method(rawValue: sender.title)!
    }
}
