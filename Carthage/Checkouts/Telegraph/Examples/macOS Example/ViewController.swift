//
//  ViewController.swift
//  macOS Example
//
//  Created by Yvo van Beek on 5/17/17.
//  Copyright © 2017 Building42. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  var demo: TelegraphDemo!

  override func viewDidLoad() {
    super.viewDidLoad()

    demo = TelegraphDemo()
    demo.start()
  }

  override func viewWillAppear() {
    self.view.wantsLayer = true
    self.view.layer?.backgroundColor = NSColor.white.cgColor
  }
}
