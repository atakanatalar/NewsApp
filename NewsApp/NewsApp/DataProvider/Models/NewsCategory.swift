//
//  NewsCategory.swift
//  NewsApp
//
//  Created by Atakan Atalar on 18.10.2024.
//

import Foundation

enum NewsCategory: String, CaseIterable {
    case general
    case business
    case entertainment
    case health
    case science
    case sports
    case technology
    
    var description: String {
        switch self {
        case .general:
            return NewsCategoryConstants.general
        case .business:
            return NewsCategoryConstants.business
        case .entertainment:
            return NewsCategoryConstants.entertainment
        case .health:
            return NewsCategoryConstants.health
        case .science:
            return NewsCategoryConstants.science
        case .sports:
            return NewsCategoryConstants.sports
        case .technology:
            return NewsCategoryConstants.technology
        }
    }
}
