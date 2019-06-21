//
//  RoutesTableViewController.swift
//  Mocky
//
//  Created by Nick Hayward on 6/21/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Cocoa

protocol RoutesTableViewControllerDelegate {
    func hello()
}

class RoutesTableViewController: NSViewController {
    
    var delegate: RoutesTableViewControllerDelegate?
    
    let tableViewData = [1,2,3,4,5,5,6,6]
    let tableView = NSTableView(frame:NSMakeRect(0, 0, 364, 200))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.window?.minSize = NSSize(width: 200, height: 400)
        
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateController(withIdentifier: "RouteDetailViewControllerID") as! RouteDetailViewController

        delegate = vc
        
        let tableContainer = NSScrollView()
        let column1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "Standard"))
        column1.width = 252
        tableView.addTableColumn(column1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.headerView?.isHidden = true
        tableContainer.documentView = tableView
        tableContainer.hasVerticalScroller = true
        view.addSubview(tableContainer)
        
////        let tableView = NSTableView(frame: .zero)
////        view.addSubview(tableView)
////        tableView.layer?.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        tableContainer.translatesAutoresizingMaskIntoConstraints = false
       tableContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
       tableContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
       tableContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
       tableContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        tableView.action = #selector(onItemClicked)
//
//        tableView.register(nil, forIdentifier: NSUserInterfaceItemIdentifier("Standard"))
//
//        tableView.delegate = self
//        tableView.dataSource = self
    }
    
    @objc private func onItemClicked() {
        print("row \(tableView.clickedRow), col \(tableView.clickedColumn) clicked")
        
        delegate?.hello()
        
    }
}

extension RoutesTableViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellIdentifier = "Standard"
        
        print ("tableView:viewForTableColumn:row: \(row)-\(tableColumn!.identifier)")
        let v = NSText ()
        v.string = "\(row)-\(tableColumn!.identifier)"
        return v
    }
    

}

extension RoutesTableViewController: NSSplitViewDelegate {
   
}
