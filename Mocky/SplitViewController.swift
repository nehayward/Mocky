//
//  SplitViewController.swift
//  Mocky
//
//  Created by Nick Hayward on 6/21/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Cocoa

class SplitViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var routesDetailVc: RouteDetailViewController = RouteDetailViewController()
        var routesTableVc: RoutesTableViewController = RoutesTableViewController()

        for item in splitViewItems{
            let isTrue = item.viewController is RouteDetailViewController
            if isTrue {
                routesDetailVc = item.viewController as! RouteDetailViewController
            }
            
            let isTrueTable = item.viewController is RoutesTableViewController
            if isTrueTable {
                routesTableVc = item.viewController as! RoutesTableViewController
            }
        }
        
        
        routesTableVc.delegate = routesDetailVc
        routesDetailVc.delegate = routesTableVc
    }

}


