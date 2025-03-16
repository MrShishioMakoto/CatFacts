//
//  APIManager.swift
//  CatFacts
//
//  Created by Kerem Gunduz on 30/03/2021.
//

import Alamofire
import Combine

protocol APIManagerProtocol {
    func fetch<T: Decodable>(urlString: String, type: T.Type) -> AnyPublisher<T, APIError>
}

final class APIManager: APIManagerProtocol {
    private let session: Session

    init(session: Session = AF) {
        self.session = session
    }
    
    func fetch<T: Decodable>(urlString: String, type: T.Type) -> AnyPublisher<T, APIError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.invalidURL(url: urlString))
                .eraseToAnyPublisher()
        }
        
        return session.request(url)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .publishDecodable(type: T.self, decoder: JSONDecoder.customDecoder())
            .value()
            .mapError { error -> APIError in
                if let afError = error.asAFError {
                    return afError.apiError
                } else {
                    return APIError.network(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

