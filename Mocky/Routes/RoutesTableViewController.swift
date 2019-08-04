//
//  RoutesTableViewController.swift
//  Mocky
//
//  Created by Nick Hayward on 6/21/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Cocoa
import Foundation

protocol RoutesTableViewControllerDelegate {
    func updateView(for route: Route, at Index: Int)
}

protocol AddButtonDelegate {
    func addNewRoute()
}

class AddButton: NSViewController {
    var delegate: AddButtonDelegate?
    override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.setValue(NSColor.controlBackgroundColor, forKey: "backgroundColor")
    }
    
    
    override func viewDidLoad() {


//        view.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
//        contentView.backgroundColor = .controlBackgroundColor
        
        let plusButton = NSButton(title: "Add Route", target: self, action: #selector(buttonClicked))
        view.addSubview(plusButton)
        
        plusButton.wantsLayer = true
//        plusButton.backgroundColor = NSColor.controlBackgroundColor

        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
    }
    
    
    @objc func buttonClicked() {
        delegate?.addNewRoute()
    }
}

class RoutesTableViewController: NSViewController {
    var delegate: RoutesTableViewControllerDelegate?
    let mockServer = MockServer()
//    var routes = [Route(path: "hello"), Route(path: "/aag/1/boardingAgent/flights/information")]
    var routes: [Route] = [] {
        didSet {
            let data = try! JSONEncoder().encode(routes)
            UserDefaults.standard.set(data, forKey: "routes")
            NotificationCenter.default.post(name: .RestartServer, object: nil)
        }
    }
    
    let tableView = NSTableView()
    
    override func viewDidLoad() {
        if let data = UserDefaults.standard.data(forKey: "routes") {
            self.routes = try! JSONDecoder().decode([Route].self, from: data)
        }

//        do {
//            let location = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("SavedRoutes.json")
//
//            let data = try Data(contentsOf: location)
//            routes = try JSONDecoder().decode([Route].self, from: data)
//
//        } catch {
//            print(error)
//        }
        

        
        super.viewDidLoad()
        view.window?.minSize = NSSize(width: 200, height: 400)
        
        let tableContainer = NSScrollView()
        let column1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "Standard"))
        tableView.addTableColumn(column1)
        
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.reloadData()
//        tableView.headerView?.isHidden = true
        tableView.headerView = nil
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
        
        tableContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive = true
        
        
        
        tableView.action = #selector(onItemClicked)
        //
        //        tableView.register(nil, forIdentifier: NSUserInterfaceItemIdentifier("Standard"))
        //
        //        tableView.delegate = self
        //        tableView.dataSource = self
        
        let footer = AddButton()
        addChild(footer)
        view.addSubview(footer.view)
        footer.view.translatesAutoresizingMaskIntoConstraints = false
        
        footer.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        footer.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        footer.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        footer.view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        footer.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(startServer), name: .StartServer, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopServer), name: .StopServer, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(restartServer), name: .RestartServer, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(loadRoutes), name: .UpdateRoutes, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveRoutes), name: .SaveRoutes, object: nil)
        
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Open URL", action: #selector(openURL), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Copy URL", action: #selector(copyURL), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Delete Route", action: #selector(delete), keyEquivalent: ""))

        tableView.menu = menu
        
        
    }
    
    override func viewDidAppear() {
        if routes.count > 0 {
            tableView.selectRowIndexes(IndexSet([0]), byExtendingSelection: true)
            delegate?.updateView(for: routes[0], at: 0)
        }
    }
    
    @objc func openURL() {
         guard tableView.clickedRow >= 0 else { return }
        
        let route =  routes[tableView.clickedRow]

        guard let url = URL(string: "https://localhost" + route.path) else { return }
        
        if NSWorkspace.shared.open(url) {
            print("default browser was successfully opened")
        }
    }
    
    @objc func copyURL() {
        guard tableView.clickedRow >= 0 else { return }
        
        let route =  routes[tableView.clickedRow]
        
        guard let url = URL(string: "https://localhost" + route.path) else { return }
        NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        
        NSPasteboard.general.setString(url.absoluteString, forType: .URL)
    }
    
    @objc func delete(){
        guard tableView.clickedRow >= 0 else { return }

        tableView.removeRows(at: IndexSet(integer: tableView.clickedRow), withAnimation: .effectGap)
        self.routes.remove(at: tableView.clickedRow)
    }
    
    @objc func loadRoutes(_ notification: NSNotification){
        if let routes = notification.userInfo?["routes"] as? [Route] {
            self.routes = routes
            tableView.reloadData()
        }
    }
    
    @objc func saveRoutes(_ notification: NSNotification){
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.nameFieldStringValue = "routes.json"
        savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        
        savePanel.begin { (result) in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                guard let filename = savePanel.url else { return }
                print(filename)
                
                guard let data = try?  JSONEncoder().encode(self.routes) else { return }
                
                try? data.write(to: filename)
            }
        }
    }
    
    @objc private func startServer() {
        mockServer.start()
        mockServer.update(with: routes)
    }
    
    
    @objc private func stopServer() {
        mockServer.stop()
    }
    
    @objc private func restartServer() {
        mockServer.update(with: routes)
    }
    
    @objc private func onItemClicked() {
        print("row \(tableView.clickedRow), col \(tableView.clickedColumn) clicked")
        guard tableView.clickedRow >= 0 else { return }
            
        delegate?.updateView(for: routes[tableView.clickedRow], at: tableView.clickedRow)
    }
}

extension RoutesTableViewController: AddButtonDelegate {
    func addNewRoute() {
        routes.append(Route(path: "/"))
        tableView.reloadData()
    }
}

extension RoutesTableViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        
        let route = routes[row]
        var retval: NSView?
        if let spareView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Standard"),
                                              owner: self) as? NSTableCellView {
            
            // We can use an old cell - no need to do anything.
            retval = spareView
            
        } else {
            
            // Create a text field for the cell
            let methodLabel = NSTextField(labelWithString: route.method.rawValue)
            methodLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
            methodLabel.font = NSFont.systemFont(ofSize: 12, weight: .light)
            methodLabel.textColor = NSColor.secondaryLabelColor
            
            let statusCodeLabel = NSTextField(labelWithString: "200 OK")
            statusCodeLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
            statusCodeLabel.font = NSFont.systemFont(ofSize: 12, weight: .light)
            statusCodeLabel.textColor = NSColor.secondaryLabelColor
            
            
            let numberOfRequests = NSTextField(labelWithString: "0")
            numberOfRequests.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
            numberOfRequests.font = NSFont.systemFont(ofSize: 12, weight: .light)
            numberOfRequests.textColor = NSColor.secondaryLabelColor
            
            let infoStack = NSStackView(views: [methodLabel, statusCodeLabel, numberOfRequests])
            infoStack.orientation = .horizontal
            infoStack.distribution = .equalSpacing
            
            
            let pathLabel = NSTextField(labelWithString: route.path)
            pathLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
            pathLabel.font = NSFont.systemFont(ofSize: 18, weight: .semibold)
        
            let stack = NSStackView(views: [pathLabel, infoStack])
            stack.orientation = .vertical
            stack.distribution = .fillProportionally
            stack.alignment = .leading
            stack.translatesAutoresizingMaskIntoConstraints = false
            
            // Create a cell
            let newCell = NSTableCellView()
            newCell.identifier = NSUserInterfaceItemIdentifier(rawValue: "Standard")
            newCell.addSubview(stack)
            
            // Constrain the text field within the cell
            stack.leadingAnchor.constraint(equalTo: newCell.leadingAnchor, constant: 10).isActive = true
            stack.trailingAnchor.constraint(equalTo: newCell.trailingAnchor, constant: -10).isActive = true
            stack.topAnchor.constraint(equalTo: newCell.topAnchor, constant: 10).isActive = true
            stack.bottomAnchor.constraint(equalTo: newCell.bottomAnchor, constant: -10).isActive = true
            
            let cell = RouteCell(route: route, frame: NSRect(x: 0, y: 0, width: tableColumn!.width, height: 20))
            cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "Standard")

            retval = cell
        }
        
        return retval
    }
    
    
    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        // left swipe
        if edge == .trailing {
            let deleteAction = NSTableViewRowAction(style: .destructive, title: "Delete", handler: { (rowAction, row) in
                // action code
                
                tableView.removeRows(at: IndexSet(integer: row), withAnimation: .effectFade)
                
                self.routes.remove(at: row)
            })
            
            deleteAction.backgroundColor = NSColor.red
            return [deleteAction]
        }
        
        return []
    }
 
    

    
}


extension RoutesTableViewController: RouteDetailViewControllerDelegate {
    func updatedRoute(route: Route, index: Int) {
        routes[index] = route
        let view = tableView.view(atColumn: 0, row: index, makeIfNecessary: false) as! RouteCell
        view.updateCell(route: route)
    }
    
    
}
