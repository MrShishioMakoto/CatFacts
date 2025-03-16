//
//  CatFactsViewModel.swift
//  CatFacts
//
//  Created by Gonçalo Almeida on 13/03/2025.
//

import Foundation
import Combine

final class CatFactsViewModel: ObservableObject {
    private let network: APIManagerProtocol
    
    @Published private(set) var catFacts: [CatFact] = []
    @Published var filteredCatFacts: [CatFact] = []
    
    @Published var isLoading: Bool = false
    @Published var error: APIError?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(network: APIManagerProtocol = APIManager()) {
        self.network = network
    }
    
    func fetchCatFacts() {
        isLoading = true
        
        network.fetch(urlString: Endpoint.baseURL, type: [CatFact].self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(err) = completion {
                    self?.error = err as APIError
                }
            } receiveValue: { [weak self] facts in
                self?.catFacts = facts
                self?.filteredCatFacts = facts
            }
            .store(in: &cancellables)
    }
    
    func numberOfCatFacts() -> Int {
        return filteredCatFacts.count
    }
    
    func catFact(at index: Int) -> CatFact? {
        guard index >= 0, index < filteredCatFacts.count else { return nil }
        return filteredCatFacts[index]
    }
    
    func filterCatFacts(by searchText: String) {
        guard !searchText.isEmpty else {
            filteredCatFacts = catFacts
            return
        }
        
        filteredCatFacts = catFacts.filter {
            $0.text.lowercased().contains(searchText.lowercased())
        }
    }
}
