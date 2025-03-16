//
//  CatFactsViewModelTests.swift
//  CatFactsTests
//
//  Created by Gonçalo Almeida on 14/03/2025.
//

import XCTest
import Combine
@testable import CatFacts

final class CatFactsViewModelTests: XCTestCase {
    
    private var viewModel: CatFactsViewModel!
    private var mockAPI: MockAPIManager!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockAPI = MockAPIManager()
        viewModel = CatFactsViewModel(network: mockAPI)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        viewModel = nil
        mockAPI = nil
        super.tearDown()
    }
    
    func testFetchCatFactsSuccess() {
        let catFactsMock = MockResponse.catFactsSample
        mockAPI.result = .success(catFactsMock)
        
        let expectation = XCTestExpectation(description: "Fetch cat facts success")
        
        viewModel.$filteredCatFacts
            .dropFirst()
            .sink { facts in
                XCTAssertEqual(facts.count, 2)
                XCTAssertEqual(facts.first?.text, "Fact 1")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchCatFacts()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchCatFactsFailure() {
        mockAPI.result = .failure(.unknown)
        
        let expectation = XCTestExpectation(description: "Fetch cat facts failure")
        
        viewModel.$error
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchCatFacts()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFilterCatFactsEmpty() {
        let catFactsMock = MockResponse.catFactsSample
        mockAPI.result = .success(catFactsMock)
        
        let loadExpectation = XCTestExpectation(description: "Load cat facts")
        
        viewModel.$filteredCatFacts
            .dropFirst()
            .sink { facts in
                if facts.count == 2 {
                    loadExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchCatFacts()
        wait(for: [loadExpectation], timeout: 1.0)
        
        viewModel.filterCatFacts(by: "")
        XCTAssertEqual(viewModel.filteredCatFacts.count, 2)
    }
    
    func testFilterCatFactsByKeyword() {
        let catFactsMock = MockResponse.catFactsSample
        mockAPI.result = .success(catFactsMock)
        
        let loadExpectation = XCTestExpectation(description: "Load cat facts")
        viewModel.$filteredCatFacts
            .dropFirst()
            .sink { facts in
                if facts.count == 2 {
                    loadExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchCatFacts()
        wait(for: [loadExpectation], timeout: 1.0)
        
        viewModel.filterCatFacts(by: "1")
        XCTAssertEqual(viewModel.filteredCatFacts.count, 1)
        XCTAssertEqual(viewModel.filteredCatFacts.first?.text, "Fact 1")
    }
}
