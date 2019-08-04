//
//  Route.swift
//  Mocky
//
//  Created by Nick Hayward on 6/25/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Foundation

struct Route: Codable {
    var path: String
    var method: Method = .GET
    var statusCode: StatusCode = .ok
    var delay: Int = 0
    var response: String = "{}"
    
    init(path: String) {
        self.path = path
    }
}
