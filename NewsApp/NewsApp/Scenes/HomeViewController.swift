//
//  ViewController.swift
//  NewsApp
//
//  Created by Atakan Atalar on 18.10.2024.
//

import UIKit

class HomeViewController: UIViewController {
    let searchController = UISearchController()
    let categorySegmentedControl = CustomSegmentedControl(segmentTitles: NewsCategory.allCases.map { $0.description })
    let sortOptionSegmentedControl = CustomSegmentedControl(segmentTitles: NewsSortOption.allCases.map { $0.description })
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let refreshControl = UIRefreshControl()
    
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupUI()
        viewModel.fetchNews()
    }
    
    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupSearchController()
        setupCategorySegmentedControl()
        setupSortOptionSegmentedControl()
        setupTableView()
        setupActivityIndicator()
        setupRefreshControl()
        setupFavoritesButton()
    }
    
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func setupCategorySegmentedControl() {
        categorySegmentedControl.buttonTapped = { [weak self] index in
            guard let self = self else { return }
            self.viewModel.selectedCategory = NewsCategory.allCases[index]
        }
        
        categorySegmentedControl.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 35)
    }
    
    private func setupSortOptionSegmentedControl() {
        sortOptionSegmentedControl.buttonTapped = { [weak self] index in
            guard let self = self else { return }
            self.viewModel.sortOption = NewsSortOption.allCases[index]
        }
        
        sortOptionSegmentedControl.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 35)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.backgroundColor = .secondarySystemBackground
        tableView.tableHeaderView = categorySegmentedControl
        tableView.frame = view.bounds
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.color = .systemBlue
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc private func refreshData() {
        viewModel.resetArticles()
        
        if let searchText = viewModel.lastSearchText, !searchText.isEmpty {
            viewModel.fetchNews(query: searchText)
        } else {
            viewModel.fetchNews()
        }
        
        refreshControl.endRefreshing()
    }
    
    private func setupFavoritesButton() {
        let favoritesButton = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"), style: .plain, target: self, action: #selector(showFavorites))
        navigationItem.rightBarButtonItem = favoritesButton
    }

    @objc private func showFavorites() {
        let favoritesVC = FavoritesViewController()
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func didUpdateArticles() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func didStartLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func didFailLoading(error: NetworkError) {
        print(error.localizedDescription)
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard viewModel.articles.indices.contains(indexPath.row) else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        let article = viewModel.articles[indexPath.row]
        cell.configure(with: article)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = viewModel.articles[indexPath.row]
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
            if viewModel.lastSearchText == nil {
                viewModel.loadMoreNews()
            } else {
                viewModel.loadMoreNews(query: viewModel.lastSearchText)
            }
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.debounceTimer?.invalidate()
        viewModel.debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            if searchText != self.viewModel.lastSearchText {
                self.viewModel.lastSearchText = searchText
                self.viewModel.resetArticles()
                self.viewModel.fetchNews(query: searchText)
            }
        }
    }
}

extension HomeViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        tableView.tableHeaderView = sortOptionSegmentedControl
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        tableView.tableHeaderView = categorySegmentedControl
        viewModel.lastSearchText = nil
    }
}

#Preview {
    let vc = HomeViewController()
    return UINavigationController(rootViewController: vc)
}
