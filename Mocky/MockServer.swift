//
//  MockServer.swift
//  Mocky
//
//  Created by Nick Hayward on 6/13/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Foundation
import Telegraph

class TelegraphStub {
    
    var server: Server?
    var routes: [HTTPRoute] = []
    
    func setUp() {
        let caCertificateURL = Bundle.main.url(forResource: "ca-crt", withExtension: "der")!
        let caCertificate = Certificate(derURL: caCertificateURL)!
        
        let identityURL = Bundle.main.url(forResource: "localhost", withExtension: "p12")!
        let identity = CertificateIdentity(p12URL: identityURL, passphrase: "development")!
       
        server = Server(identity: identity, caCertificates: [caCertificate])
        
        server?.route(.GET, "/aag/1/boardingAgent/flights/information", handle)
        server?.route(.GET, "/aag/1/boardingAgent/flights/guests", handle)
        server?.route(.GET, "/aag/1/boardingAgent/flights/staff", handle)
        server?.route(.GET, "/aag/1/boardingAgent/app/configuration", handle)
        
        
        try! server?.start(port: 443)
    }
    
    func tearDown() {
        server?.stop()
    }
    
    func handle(request: HTTPRequest) -> HTTPResponse {
        let fileName = request.uri.path.split(separator: "/").last?.capitalized
        let testBundle = Bundle(for: type(of: self))
        let filePath = testBundle.path(forResource: fileName, ofType: "json")
        let fileUrl = URL(fileURLWithPath: filePath!)
        let data = try! Data(contentsOf: fileUrl, options: .uncached)
        
        return HTTPResponse(body: data)
    }
    
    func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    public func handleFile(url: URL, request: HTTPRequest) -> HTTPResponse {
        let data = try! Data(contentsOf: url, options: .uncached)
        
        return HTTPResponse(body: data)
    }
    
    func updateRoutes(){
        for route in routes {
            server?.route(route)
        }
    }
}
