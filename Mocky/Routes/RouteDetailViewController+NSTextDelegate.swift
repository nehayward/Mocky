//
//  RouteDetailViewController+NSTextDelegate.swift
//  Mocky
//
//  Created by Nick Hayward on 8/4/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Foundation
import Cocoa

extension RouteDetailViewController: NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        saveButton.isHidden = false
        formatTextInTextView(textView: textView)
    }
    
    
    func formatTextInTextView(textView: NSTextView) {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size:(textView.bounds.size))
        layoutManager.addTextContainer(textContainer)
        
        let selectedRange = textView.selectedRange
        let text = textView.string
        
        // This will give me an attributedString with the base text-style
        var attributedString = NSMutableAttributedString(string: text)
        
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.controlTextColor, range: NSMakeRange(0, text.count))
        attributedString.addAttribute(NSAttributedString.Key.font, value: NSFont(name: "Hack", size: 14)!, range: NSMakeRange(0, text.count))
        
        match4(text: text, attributedString: &attributedString)
        
        
        let regex = try? NSRegularExpression(pattern: #"("(.*?)")"#, options: [])
        let matches = regex!.matches(in: text, options: [], range: NSMakeRange(0, text.count))
        
        for match in matches {
            let matchRange = match.range(at: 0)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.init(named: "String"), range: matchRange)
        }
        
        
        
        match2(text: text, attributedString: &attributedString)

        match3(text: text, attributedString: &attributedString)
        
        textView.textStorage?.setAttributedString(attributedString)
        textView.selectedRange = selectedRange
    }
    
    // Type
    func match2(text: String, attributedString:  inout NSMutableAttributedString) {
        let regex = try? NSRegularExpression(pattern: #"("[^:,]*")[^:,\n]"#, options: [])
        let matches = regex!.matches(in: text, options: [], range: NSMakeRange(0, text.count))
        
        for match in matches {
            let matchRange = match.range(at: 0)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.init(named: "TypeColor"), range: matchRange)
            //            attributedString.addAttribute(NSAttributedString.Key.font, value: NSFont.systemFont(ofSize: 12, weight: .heavy), range: matchRange)
        }
    }
    
    // Boolean
    func match3(text: String, attributedString:  inout NSMutableAttributedString) {
        let regex = try? NSRegularExpression(pattern: "true|false|null", options: [])
        let matches = regex!.matches(in: text, options: [], range: NSMakeRange(0, text.count))
        
        for match in matches {
            let matchRange = match.range(at: 0)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.init(named: "Boolean"), range: matchRange)
            //            attributedString.addAttribute(NSAttributedString.Key.font, value: NSFont.systemFont(ofSize: 12, weight: .heavy), range: matchRange)
        }
    }
    
    
    // number
    func match4(text: String, attributedString:  inout NSMutableAttributedString) {
        let regex = try? NSRegularExpression(pattern: #"([^"]\d+)"#, options: [])
        let matches = regex!.matches(in: text, options: [], range: NSMakeRange(0, text.count))
        
        for match in matches {
            let matchRange = match.range(at: 0)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.init(named: "NumberColor"), range: matchRange)
        }
    }
    
}
