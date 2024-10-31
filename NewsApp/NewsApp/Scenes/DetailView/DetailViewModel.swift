//
//  DetailViewModel.swift
//  NewsApp
//
//  Created by Atakan Atalar on 31.10.2024.
//

import Foundation
import UIKit

class DetailViewModel {
    private let article: Article
    
    var isFavorite: Bool = false {
        didSet {
            favoriteIconName = isFavorite ? SFSymbolsConstants.bookmarkFill : SFSymbolsConstants.bookmark
        }
    }
    
    var favoriteIconName: String = SFSymbolsConstants.bookmark
    
    var title: String? { article.title }
    var description: String? { article.description }
    var content: String? { article.content }
    var source: String? { article.source?.name }
    var dateText: String? {
        guard let publishedAt = article.publishedAt else { return nil }
        return DateHelper.formatDateString(publishedAt)
    }
    
    var imageUrl: URL? {
        guard let urlString = article.urlToImage else { return nil }
        return URL(string: urlString)
    }
    
    var articleURL: String? { article.url }
    
    init(article: Article) {
        self.article = article
        loadFavoriteState()
    }
    
    private func loadFavoriteState() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            switch result {
            case .success(let favorites):
                self?.isFavorite = favorites.contains { $0.url == self?.article.url }
            case .failure:
                self?.isFavorite = false
            }
        }
    }
    
    func toggleFavorite(completion: @escaping (Result<Void, Error>) -> Void) {
        let actionType: PersistenceActionType = isFavorite ? .remove : .add
        PersistenceManager.updateWith(favorite: article, actionType: actionType) { [weak self] error in
            if let error = error {
                completion(.failure(error))
            } else {
                self?.isFavorite.toggle()
                completion(.success(()))
            }
        }
    }
    
    func getDefaultImage() -> UIImage {
        return UIImage(systemName: SFSymbolsConstants.newspaper)?.withRenderingMode(.alwaysTemplate) ?? UIImage()
    }
}
