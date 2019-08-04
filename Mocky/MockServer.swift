//
//  MockServer.swift
//  Mocky
//
//  Created by Nick Hayward on 6/13/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Foundation
import Telegraph

class MockServer {
    
    private var server: Server?
    private var routes: [HTTPRoute] = []
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(restartServer), name: .RestartServer, object: nil)
    }
    
    func start(port: Int = 443) {
        let caCertificateURL = Bundle.main.url(forResource: "ca-crt", withExtension: "der")!
        let caCertificate = Certificate(derURL: caCertificateURL)!
        
        let identityURL = Bundle.main.url(forResource: "localhost", withExtension: "p12")!
        let identity = CertificateIdentity(p12URL: identityURL, passphrase: "mocky")!
        
        server = Server(identity: identity, caCertificates: [caCertificate])

        try! server?.start(port: port, interface: nil)
    }
    
    func stop(){
        server?.stop()
    }
    
    @objc private func restartServer() {
        guard let server = server else { return }
        if !server.isRunning {
            return
        }
        
        server.stop()
        self.server = nil
        start()
    }
    
    func update(with routes: [Route]) {
        for route in routes {
            let method = HTTPMethod(stringLiteral: route.method.rawValue)
            server?.route(method, route.path, response: { () -> HTTPResponse in
        
                sleep(UInt32(route.delay))
                
                let data = route.response.data(using: .utf8)!
                let httpStatus = HTTPStatus(code: route.statusCode.rawValue, phrase: "")
                let httpVersion = HTTPVersion(major: 1, minor: 0)
                let httpHeaders = HTTPHeaders()
                let response = HTTPResponse(httpStatus, version: httpVersion, headers: httpHeaders, body: data)
                
                return response
            })
        }
    }
}
