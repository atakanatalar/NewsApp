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
}
