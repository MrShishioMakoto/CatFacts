//
//  MockResponse.swift
//  CatFactsTests
//
//  Created by Gonçalo Almeida on 14/03/2025.
//

import Foundation
@testable import CatFacts

enum MockResponse {
    static var catFactsSample: [CatFact] {
        let catFactsMock = [
            CatFact(
                id: "123",
                text: "Fact 1",
                status: Status(verified: true, sentCount: 0),
                createdAt: Date()
            ),
            CatFact(
                id: "456",
                text: "Fact 2",
                status: Status(verified: false, sentCount: 0),
                createdAt: Date()
            )
        ]
        
        return catFactsMock
    }
}
