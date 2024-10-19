//
//  NewsAPIEndpoint.swift
//  NewsApp
//
//  Created by Atakan Atalar on 18.10.2024.
//

import Foundation

enum NewsAPIEndpoint {
    case topHeadlines(category: NewsCategory?, page: Int, pageSize: Int)
    case everything(query: String?, page: Int, pageSize: Int)
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
        case .topHeadlines(let category, let page, let pageSize):
            params["country"] = "us"
            
            if let category = category {
                params["category"] = category.rawValue
            }
            
            params["page"] = "\(page)"
            params["pageSize"] = "\(pageSize)"
            
            return params
        case .everything(let query, let page, let pageSize):
            if let query = query {
                params["q"] = query
            }
            
            params["page"] = "\(page)"
            params["pageSize"] = "\(pageSize)"
            
            return params
        }
    }
}
