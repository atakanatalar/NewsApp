//
//  Endpoint.swift
//  NewsApp
//
//  Created by Atakan Atalar on 18.10.2024.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: String] { get }
    var url: URL? { get }
}

extension Endpoint {
    var url: URL? {
        var urlComponents = URLComponents(string: baseURL + path)
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        if !queryItems.isEmpty {
            urlComponents?.queryItems = queryItems
        }
        
        return urlComponents?.url
    }
}
