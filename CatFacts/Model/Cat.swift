//
//  Cat.swift
//  CatFacts
//
//  Created by Kerem Gunduz on 30/03/2021.
//

import Foundation

struct CatFact: Codable {
    let id: String
    let text: String
    let status: Status
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case text
        case status
        case createdAt
    }
    
    var isNew: Bool {
        let ninetyDaysInSeconds: TimeInterval = 90 * 24 * 60 * 60
        return Date().timeIntervalSince(createdAt) < ninetyDaysInSeconds
    }
}

struct Status: Codable {
    let verified: Bool
    let sentCount: Int
}
