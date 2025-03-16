//
//  MockAPIManager.swift
//  CatFactsTests
//
//  Created by Gonçalo Almeida on 14/03/2025.
//

import Combine
import Foundation
@testable import CatFacts

final class MockAPIManager: APIManagerProtocol {
    var result: Result<[CatFact], APIError> = .success([])

    func fetch<T: Decodable>(urlString: String, type: T.Type) -> AnyPublisher<T, APIError> {
        guard type == [CatFact].self, let casted = result as? Result<T, APIError> else {
            return Fail(error: .unknown).eraseToAnyPublisher()
        }
        
        return casted.publisher.eraseToAnyPublisher()
    }
}
