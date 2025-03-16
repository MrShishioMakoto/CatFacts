//
//  MockURLProtocol.swift
//  CatFactsTests
//
//  Created by Gonçalo Almeida on 14/03/2025.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var testResponses: [URL: (data: Data?, statusCode: Int, error: Error?)] = [:]

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let url = request.url,
              let responseInfo = MockURLProtocol.testResponses[url] else {
            let error = NSError(domain: "No mock response", code: 999, userInfo: nil)
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        let response = HTTPURLResponse(url: url,
                                       statusCode: responseInfo.statusCode,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        if let data = responseInfo.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let error = responseInfo.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
    }
}
