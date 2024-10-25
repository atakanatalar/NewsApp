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
            return "Newest"
        case .popularity:
            return "Popular"
        case .relevancy:
            return "Relevant"
        }
    }
}
