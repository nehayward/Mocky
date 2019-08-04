//
//  RouteDetailViewController+NSTextFieldDelegate.swift
//  Mocky
//
//  Created by Nick Hayward on 8/4/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Foundation
import Cocoa

extension RouteDetailViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        if let textField = obj.object as? NSTextField, self.path.identifier == textField.identifier {
            
            route?.path = path.stringValue
        }
        
        if let textField = obj.object as? NSTextField, self.statusCode.identifier == textField.identifier && statusCode.stringValue.count == 3 {
            guard let statusCodeNumber = Int(statusCode.stringValue)  else { return }
            route?.statusCode = StatusCode(rawValue: statusCodeNumber) ?? StatusCode.accepted
        }
    }
}
