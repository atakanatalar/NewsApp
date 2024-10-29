//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Atakan Atalar on 22.10.2024.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didUpdateArticles()
    func didStartLoading()
    func didFailLoading(error: NetworkError)
}

class HomeViewModel {
    private let networkManager = NetworkManager()
    var articles: [Article] = []
    var currentPage: Int = 1
    var totalResults: Int = 0
    var incomingResults: Int = 0
    var isLoading: Bool = false
    var lastSearchText: String?
    var debounceTimer: Timer?
    
    weak var delegate: HomeViewModelDelegate?
    
    var selectedCategory: NewsCategory = .general {
        didSet {
            resetArticles()
            fetchNews()
        }
    }
    
    var sortOption: NewsSortOption = .publishedAt {
        didSet {
            resetArticles()
            fetchNews(query: lastSearchText)
        }
    }
    
    func resetArticles() {
        currentPage = 1
        articles.removeAll()
        delegate?.didUpdateArticles()
    }
    
    func loadMoreNews(query: String? = nil) {
        incomingResults = currentPage * 20
        
        if !isLoading && incomingResults < totalResults {
            currentPage += 1
            fetchNews(page: currentPage, query: query)
        }
    }
    
    func fetchNews(page: Int = 1, pageSize: Int = 20, query: String? = nil) {
        let endpoint: NewsAPIEndpoint
        
        if let searchText = query, !searchText.isEmpty {
            endpoint = .everything(query: searchText, page: page, pageSize: pageSize, sortBy: sortOption)
        } else {
            endpoint = .topHeadlines(category: selectedCategory, page: page, pageSize: pageSize)
        }
        
        isLoading = true
        delegate?.didStartLoading()
        
        networkManager.request(endpoint: endpoint) { [weak self] (result: Result<NewsResponse, NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let newsResponse):
                self.totalResults = newsResponse.totalResults
                let filteredArticles = newsResponse.articles.filter { $0.source?.name != "[Removed]" }
                self.articles.append(contentsOf: filteredArticles)
                self.isLoading = false
                self.delegate?.didUpdateArticles()
            case .failure(let error):
                self.isLoading = false
                self.delegate?.didFailLoading(error: error)
            }
        }
    }
}
