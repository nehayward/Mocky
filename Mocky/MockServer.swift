//
//  MockServer.swift
//  Mocky
//
//  Created by Nick Hayward on 6/13/19.
//  Copyright © 2019 Nick Hayward. All rights reserved.
//

import Foundation
import Security
import Telegraph

class MockServer {
    
    public typealias KeychainQuery = [NSString: AnyObject]
    
    private var server: Server?
    private var routes: [HTTPRoute] = []
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(restartServer), name: .RestartServer, object: nil)
    }
    
    func start(port: Int = 443) {
        let caCertificateURL = Bundle.main.url(forResource: "ca-crt", withExtension: "der")!
        let caCertificate = Certificate(derURL: caCertificateURL)!
        
        let identityURL = Bundle.main.url(forResource: "localhost", withExtension: "p12")!
        guard let data = try? Data(contentsOf: identityURL) else { return }
        
        guard let secIdentity = importPKCS12(data: data, passphrase: "mocky") else { return }
        
        let mockyCertIdentity = CertificateIdentity(rawValue: secIdentity)
        
        server = Server(identity: mockyCertIdentity, caCertificates: [caCertificate])
        
        try! server?.start(port: port, interface: nil)
    }
    
    func importPKCS12(data: Data, passphrase: String, options: KeychainQuery = KeychainQuery()) -> SecIdentity? {
        var query = options
        query[kSecImportExportPassphrase] = passphrase as NSString
        
        // Import the data
        var importResult: CFArray?
        let status = withUnsafeMutablePointer(to: &importResult) { SecPKCS12Import(data as NSData, query as CFDictionary, $0) }
        
        guard status == errSecSuccess else { return nil }
        
        // The result is an array of dictionaries, we are looking for the one that contains the identity
        let importArray = importResult as? [[NSString: AnyObject]]
        let importIdentity = importArray?.compactMap { dict in dict[kSecImportItemIdentity as NSString] }.first
        
        // Let's double check that we have a result and that it is a SecIdentity
        guard let rawResult = importIdentity, CFGetTypeID(rawResult) == SecIdentityGetTypeID() else { return nil }
        let result = rawResult as! SecIdentity
        
        return result
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
            let path = makePathUnique(path: route.path)
            // MARK: Allow Parameters
            server?.route(method, path, response: { () -> HTTPResponse in
                
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
    
    func makePathUnique(path: String) -> String {
        return path
       return path.replacingOccurrences(of: "?", with: "/")
    }
}
