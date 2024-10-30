//
//  FavoritesViewController.swift
//  NewsApp
//
//  Created by Atakan Atalar on 26.10.2024.
//

import UIKit

class FavoritesViewController: NADataLoadingViewController {
    private let tableView = UITableView()
    private var favoriteArticles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        title = "Favorites"
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.backgroundColor = .secondarySystemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "FavoriteCell")
    }
    
    private func loadFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favorites):
                self.updateUI(with: favorites)
            case .failure(let error):
                print("Error loading favorites: \(error.rawValue)")
            }
        }
    }
    
    func updateUI(with favoriteArticles: [Article]) {
        self.favoriteArticles = favoriteArticles
        
        if self.favoriteArticles.isEmpty {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.showEmptyStateView(with: "You don’t have any favorite news", in: self.view)
            }
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! NewsTableViewCell
        let article = favoriteArticles[indexPath.row]
        cell.configure(with: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = favoriteArticles[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.article = selectedArticle
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let articleToDelete = favoriteArticles[indexPath.row]
            PersistenceManager.updateWith(favorite: articleToDelete, actionType: .remove) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print("Failed to remove favorite: \(error.rawValue)")
                } else {
                    DispatchQueue.main.async {
                        self.favoriteArticles.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .left)
                        self.loadFavorites()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
