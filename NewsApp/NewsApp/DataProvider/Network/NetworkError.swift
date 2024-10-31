//
//  NetworkError.swift
//  NewsApp
//
//  Created by Atakan Atalar on 18.10.2024.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .badURL:
            return NetworkErrorConstants.badURL
        case .requestFailed:
            return NetworkErrorConstants.requestFailed
        case .decodingError:
            return NetworkErrorConstants.decodingError
        }
    }
}
