//
//  APIError.swift
//  CatFacts
//
//  Created by Gonçalo Almeida on 13/03/2025.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL(url: String)
    case invalidResponse(statusCode: Int)
    case decodeError(Error)
    case network(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .invalidResponse(let statusCode):
            return "Invalid Response. Status code: \(statusCode)"
        case .decodeError(let underlying):
            return "Decoding error: \(underlying.localizedDescription)"
        case .network(let underlying):
            return "Network error: \(underlying.localizedDescription)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
