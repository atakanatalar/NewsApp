//
//  FavoriteManager.swift
//  NewsApp
//
//  Created by Atakan Atalar on 26.10.2024.
//

import Foundation

class FavoriteManager {
    private let favoritesKey = "favoriteArticles"
    static let shared = FavoriteManager()
    
    private init() {}
    
    func saveArticle(_ article: Article) {
        var favorites = loadFavorites()
        favorites.append(article)
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
    
    func removeArticle(_ article: Article) {
        var favorites = loadFavorites()
        favorites.removeAll { $0.url == article.url }
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
    
    func loadFavorites() -> [Article] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let favorites = try? JSONDecoder().decode([Article].self, from: data) else {
            return []
        }
        return favorites
    }
    
    func isFavorite(_ article: Article) -> Bool {
        return loadFavorites().contains { $0.url == article.url }
    }
}
