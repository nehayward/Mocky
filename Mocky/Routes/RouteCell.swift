//
//  RouteCell.swift
//  Mocky
//
//  Created by Nick Hayward on 7/31/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Foundation
import AppKit

class RouteCell: NSTableCellView {
    
    let methodLabel: NSTextField
    let pathLabel: NSTextField
    let delayLabel: NSTextField
    let statusCodeLabel: NSTextField

    
    init(route: Route, frame: NSRect) {
        
        methodLabel = NSTextField(labelWithString: route.method.rawValue)
        methodLabel.font = NSFont.systemFont(ofSize: 12, weight: .light)
        methodLabel.textColor = NSColor.secondaryLabelColor
        
        statusCodeLabel = NSTextField(labelWithString: "200")
        statusCodeLabel.font = NSFont.systemFont(ofSize: 12, weight: .light)
        statusCodeLabel.textColor = NSColor.secondaryLabelColor
        
        
        delayLabel = NSTextField(labelWithString: "No Delay")
        delayLabel.font = NSFont.systemFont(ofSize: 12, weight: .light)
        delayLabel.textColor = NSColor.secondaryLabelColor
        
        
        pathLabel = NSTextField(labelWithString: route.path)
        pathLabel.font = NSFont.systemFont(ofSize: 18, weight: .semibold)
        
        
        super.init(frame: frame)
        
        
        
        let infoStack = NSStackView(views: [methodLabel, statusCodeLabel, delayLabel])
        infoStack.orientation = .horizontal
        infoStack.distribution = .equalSpacing
        
        let stack = NSStackView(views: [pathLabel, infoStack])
        stack.orientation = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        self.identifier = NSUserInterfaceItemIdentifier(rawValue: "Standard")
        self.addSubview(stack)
        
        // Constrain the text field within the cell
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        methodLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        delayLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func updateCell(route: Route) {
        methodLabel.stringValue = route.method.rawValue
        statusCodeLabel.stringValue = String(route.statusCode.rawValue)
        pathLabel.stringValue = route.path
        
        switch route.delay {
        case 0:
            delayLabel.stringValue = "No Delay"
        case 1:
            delayLabel.stringValue = "1 Second"
        default:
            delayLabel.stringValue = "\(route.delay) Seconds"
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDraw() {
        
    }
    
}
