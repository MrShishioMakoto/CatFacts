//
//  APIManagerTests.swift
//  CatFactsTests
//
//  Created by Gonçalo Almeida on 14/03/2025.
//

import XCTest
import Combine
import Alamofire
@testable import CatFacts

final class APIManagerTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func testFetchSuccess() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss Z"
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonData = try! encoder.encode(MockResponse.catFactsSample)
        
        let testURL = URL(string: Endpoint.baseURL)!
        MockURLProtocol.testResponses = [
            testURL: (data: jsonData, statusCode: 200, error: nil)
        ]
        
        let session = makeTestSession()
        let apiManager = APIManager(session: session)
        
        let expectation = XCTestExpectation(description: "Fetch cat facts success")
        
        apiManager.fetch(urlString: Endpoint.baseURL, type: [CatFact].self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Expected success but received error: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { catFacts in
                XCTAssertEqual(catFacts.count, 2)
                XCTAssertEqual(catFacts.first?.text, "Fact 1")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchFailure() {
        let testURL = URL(string: Endpoint.baseURL)!
        MockURLProtocol.testResponses = [
            testURL: (data: nil, statusCode: 400, error: nil)
        ]
        
        let session = makeTestSession()
        let apiManager = APIManager(session: session)
        
        let expectation = XCTestExpectation(description: "Fetch cat facts failure")
        
        apiManager.fetch(urlString: Endpoint.baseURL, type: [CatFact].self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if case .invalidResponse(let code) = error {
                        XCTAssertEqual(code, 400)
                        expectation.fulfill()
                    } else {
                        XCTFail("Unexpected error: \(error)")
                    }
                case .finished:
                    XCTFail("Should not finish successfully")
                }
            } receiveValue: { _ in
                XCTFail("Should not return value on failure")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchInvalidURL() {
        let invalidURLString = "not_a_valid_url://"
        let session = makeTestSession()
        let apiManager = APIManager(session: session)
        
        let expectation = XCTestExpectation(description: "Fetch cat facts invalid URL")
        
        apiManager.fetch(urlString: invalidURLString, type: [CatFact].self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if case .invalidURL(let urlStr) = error {
                        XCTAssertEqual(urlStr, invalidURLString)
                        expectation.fulfill()
                    } else {
                        XCTFail("Unexpected error: \(error)")
                    }
                case .finished:
                    XCTFail("Should not finish successfully")
                }
            } receiveValue: { _ in
                XCTFail("Should not return value on failure")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}

extension APIManagerTests {
    func makeTestSession() -> Session {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return Session(configuration: configuration)
    }
}
