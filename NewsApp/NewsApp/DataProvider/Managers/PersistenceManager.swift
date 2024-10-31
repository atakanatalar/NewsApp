//
//  FavoriteManager.swift
//  NewsApp
//
//  Created by Atakan Atalar on 26.10.2024.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceError: Error {
    case unableToFavorite
    
    var localizedDescription: String {
        switch self {
        case .unableToFavorite:
            PersistenceErrorConstants.unableToFavorite
        }
    }
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Article, actionType: PersistenceActionType, completed: @escaping (PersistenceError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                switch actionType {
                case .add:
                    favorites.append(favorite)
                case .remove:
                    favorites.removeAll { $0.url == favorite.url }
                }
                completed(save(favorites: favorites))
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[Article], PersistenceError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Article].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Article]) -> PersistenceError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
