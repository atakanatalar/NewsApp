//
//  FavoritesViewModel.swift
//  NewsApp
//
//  Created by Atakan Atalar on 31.10.2024.
//

import Foundation

class FavoritesViewModel {
    private(set) var favoriteArticles: [Article] = []
    
    func loadFavorites(completion: @escaping (Result<[Article], Error>) -> Void) {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                self.favoriteArticles = favorites
                completion(.success(favorites))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func removeFavorite(at index: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let articleToDelete = favoriteArticles[index]
        PersistenceManager.updateWith(favorite: articleToDelete, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
            } else {
                self.favoriteArticles.remove(at: index)
                completion(.success(()))
            }
        }
    }
}

