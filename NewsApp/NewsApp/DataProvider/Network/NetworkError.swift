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
            return "Invalid URL, please try again"
        case .requestFailed:
            return "Request failed, check your connection"
        case .decodingError:
            return "Data error, please try later"
        }
    }
}
