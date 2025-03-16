//
//  AFError+Ext.swift
//  CatFacts
//
//  Created by Gonçalo Almeida on 13/03/2025.
//

import Foundation
import Alamofire

extension AFError {
    var apiError: APIError {
        if let underlying = self.underlyingError {
            return .network(underlying)
        }
        switch self {
        case .invalidURL(let url):
            return .invalidURL(url: String(describing: url))
        case .responseValidationFailed(let reason):
            switch reason {
            case .unacceptableStatusCode(let code):
                return .invalidResponse(statusCode: code)
            default:
                return .network(self)
            }
        case .responseSerializationFailed(let reason):
            switch reason {
            case .decodingFailed(let decodeError):
                return .decodeError(decodeError)
            default:
                return .network(self)
            }
        default:
            return .unknown
        }
    }
}
