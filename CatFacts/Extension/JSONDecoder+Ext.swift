//
//  JSONDecoder+Ext.swift
//  CatFacts
//
//  Created by Gonçalo Almeida on 13/03/2025.
//

import Foundation

extension JSONDecoder {
    static func customDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss Z"
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }
}
