//
//  NewsAPIEndpoint.swift
//  NewsApp
//
//  Created by Atakan Atalar on 18.10.2024.
//

import Foundation

enum NewsAPIEndpoint {
    case topHeadlines(category: NewsCategory)
    case everything(query: String?)
}

extension NewsAPIEndpoint: Endpoint {
    var baseURL: String {
        return NetworkConstants.baseURL
    }
    
    var path: String {
        switch self {
        case .topHeadlines:
            return NetworkConstants.Endpoint.topHeadlines
        case .everything:
            return NetworkConstants.Endpoint.everything
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String: String] {
        var params = [String: String]()
        
        switch self {
        case .topHeadlines(let category):
            params["country"] = "us"
            
            if category == .all {
                return params
            } else {
                params["category"] = category.rawValue
            }
        case .everything(let query):
            if let query = query {
                params["q"] = query
            }
        }
        
        return params
    }
}
