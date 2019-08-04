//
//  Extension+Data.swift
//  Mocky
//
//  Created by Nick Hayward on 8/4/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Foundation

extension Data {
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
     
        return prettyPrintedString as String
    }
}
