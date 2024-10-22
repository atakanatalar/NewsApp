//
//  ViewController.swift
//  NewsApp
//
//  Created by Atakan Atalar on 18.10.2024.
//

import UIKit

class HomeViewController: UIViewController {
    let searchController = UISearchController()
    let customSegmentedControl = CustomSegmentedControl(segmentTitles: NewsCategory.allCases.map { $0.description })
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupUI()
        viewModel.fetchNews()
    }
    
    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        title = "News App"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupSearchController()
        setupSegmentedControl()
        setupTableView()
        setupActivityIndicator()
    }
    
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func setupSegmentedControl() {
        customSegmentedControl.buttonTapped = { [weak self] index in
            guard let self = self else { return }
            self.viewModel.selectedCategory = NewsCategory.allCases[index]
        }
        
        customSegmentedControl.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 35)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.backgroundColor = .secondarySystemBackground
        tableView.tableHeaderView = customSegmentedControl
        tableView.frame = view.bounds
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.color = .systemBlue
        activityIndicator.hidesWhenStopped = true
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
            viewModel.loadMoreNews()
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        viewModel.resetArticles()
        viewModel.fetchNews(query: searchText)
    }
}

extension HomeViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        tableView.tableHeaderView = nil
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        tableView.tableHeaderView = customSegmentedControl
    }
}

#Preview {
    let vc = HomeViewController()
    return UINavigationController(rootViewController: vc)
}
