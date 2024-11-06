//
//  ViewController.swift
//  NewsApp
//
//  Created by Atakan Atalar on 18.10.2024.
//

import UIKit
import Toast
import TipKit

class HomeViewController: NADataLoadingViewController {
    let searchController = UISearchController()
    let categorySegmentedControl = CustomSegmentedControl(segmentTitles: NewsCategory.allCases.map { $0.description })
    let sortOptionSegmentedControl = CustomSegmentedControl(segmentTitles: NewsSortOption.allCases.map { $0.description })
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    var favoritesButton: UIBarButtonItem?
    var openFavoritesTip = OpenFavoritesTip()
    
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupUI()
        incrementAppOpenCount()
        viewModel.fetchNews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showOpenFavoritesTip()
    }
    
    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        title = HomeViewConstants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupSearchController()
        setupCategorySegmentedControl()
        setupSortOptionSegmentedControl()
        setupTableView()
        setupRefreshControl()
        setupFavoritesButton()
    }
    
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = HomeViewConstants.searchPlaceholder
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
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: HomeViewConstants.tableViewCellID)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.tableHeaderView = categorySegmentedControl
        tableView.frame = view.bounds
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
        favoritesButton = UIBarButtonItem(image: UIImage(systemName: SFSymbolsConstants.bookmarkFill), style: .plain, target: self, action: #selector(showFavorites))
        navigationItem.rightBarButtonItem = favoritesButton
    }
    
    private func showOpenFavoritesTip() {
        Task {
            if #available(iOS 17.0, *) {
                for await shouldDisplay in openFavoritesTip.shouldDisplayUpdates {
                    if shouldDisplay {
                        let controller = TipUIPopoverViewController(openFavoritesTip, sourceItem: favoritesButton!)
                        present(controller, animated: true)
                    } else if presentedViewController is TipUIPopoverViewController {
                        dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    private func incrementAppOpenCount() {
        Task {
            if #available(iOS 17.0, *) {
                await OpenFavoritesTip.appOpenedCount.donate()
            }
        }
    }
    
    @objc private func showFavorites() {
        if #available(iOS 17.0, *) {
            openFavoritesTip.invalidate(reason: .tipClosed)
        }
        let favoritesVC = FavoritesViewController()
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func didUpdateArticles() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.dismissLoadingView()
        }
    }
    
    func didStartLoading() {
        DispatchQueue.main.async {
            self.showLoadingView()
        }
    }
    
    func didFailLoading(error: NetworkError) {
        print(error.localizedDescription)
        DispatchQueue.main.async {
            self.dismissLoadingView()
            
            let toast = Toast.default(
                image: UIImage(systemName: SFSymbolsConstants.error)!,
                title: ToastConstants.errorTitle,
                subtitle: error.localizedDescription
            )
            toast.show(haptic: .error, after: 0)
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewConstants.tableViewCellID, for: indexPath) as? NewsTableViewCell else {
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
        
        guard !searchController.isBeingDismissed else { return }
        
        if searchText?.isEmpty == false {
            tableView.tableHeaderView = sortOptionSegmentedControl
        } else {
            tableView.tableHeaderView = nil
        }
    }
}

extension HomeViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        tableView.tableHeaderView = nil
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
