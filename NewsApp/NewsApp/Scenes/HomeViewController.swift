//
//  ViewController.swift
//  NewsApp
//
//  Created by Atakan Atalar on 18.10.2024.
//

import UIKit

class HomeViewController: UIViewController {
    let networkManager = NetworkManager()
    var articles: [Article] = []
    let tableView = UITableView()
    let searchController = UISearchController()
    
    var selectedCategory: NewsCategory = .general
    var currentPage: Int = 1
    var totalResults: Int = 0
    var isLoading: Bool = false
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        title = "News App"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.backgroundColor = .secondarySystemBackground
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        activityIndicator.center = view.center
        activityIndicator.color = .systemBlue
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", image: UIImage(systemName: "line.3.horizontal.decrease.circle"), primaryAction: nil, menu: createCategoryMenu())
        
        fetchNews()
    }
    
    func createCategoryMenu() -> UIMenu {
        let categories = NewsCategory.allCases
        
        let actions = categories.map { category in
            UIAction(title: category.description, state: category == selectedCategory ? .on : .off, handler: { [weak self] _ in
                self?.filterNews(by: category)
            })
        }
        
        let menu = UIMenu(title: "Select Category", options: .displayInline, children: actions)
        
        return menu
    }
    
    func filterNews(by category: NewsCategory) {
        selectedCategory = category
        
        navigationItem.rightBarButtonItem?.menu = createCategoryMenu()
        
        currentPage = 1
        articles.removeAll()
        fetchNews(page: currentPage)
    }
    
    func fetchNews(page: Int = 1, pageSize: Int = 20) {
        let endpoint: NewsAPIEndpoint
        
        if let searchText = navigationItem.searchController?.searchBar.text, !searchText.isEmpty {
            endpoint = .everything(query: searchText, page: page, pageSize: pageSize)
        } else {
            endpoint = .topHeadlines(category: selectedCategory, page: page, pageSize: pageSize)
        }
        
        isLoading = true
        activityIndicator.startAnimating()
        
        networkManager.request(endpoint: endpoint) { [weak self] (result: Result<NewsResponse, NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let newsResponse):
                self.totalResults = newsResponse.totalResults
                self.articles.append(contentsOf: newsResponse.articles)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.isLoading = false
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.isLoading = false
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard articles.indices.contains(indexPath.row) else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        let article = articles[indexPath.row]
        cell.configure(with: article)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = articles[indexPath.row]
        
        let detailVC = DetailViewController()
        detailVC.article = selectedArticle
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            loadMoreNews()
        }
    }
    
    func loadMoreNews() {
        if !isLoading && articles.count < totalResults {
            currentPage += 1
            fetchNews(page: currentPage)
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        articles.removeAll()
        currentPage = 1
        fetchNews(page: currentPage)
    }
}

#Preview {
    let vc = UINavigationController(rootViewController: HomeViewController())
    return vc
}
