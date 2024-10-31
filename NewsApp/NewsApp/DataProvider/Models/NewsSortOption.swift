//
//  NewsSortOption.swift
//  NewsApp
//
//  Created by Atakan Atalar on 25.10.2024.
//

import Foundation

enum NewsSortOption: String, CaseIterable {
    case publishedAt
    case popularity
    case relevancy
    
    var description: String {
        switch self {
        case .publishedAt:
            return NewsSortOptionConstants.publishedAt
        case .popularity:
            return NewsSortOptionConstants.popularity
        case .relevancy:
            return NewsSortOptionConstants.relevancy
        }
    }
}
