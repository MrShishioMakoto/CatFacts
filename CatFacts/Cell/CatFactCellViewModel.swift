//
//  CatFactCellViewModel.swift
//  CatFacts
//
//  Created by Gonçalo Almeida on 13/03/2025.
//

import Foundation

final class CatFactCellViewModel {
    let factDescription: String
    let isVerified: Bool
    let isNew: Bool
    
    init(factDescription: String, isVerified: Bool, isNew: Bool) {
        self.factDescription = factDescription
        self.isVerified = isVerified
        self.isNew = isNew
    }
}
