//
//  FavoritesViewController.swift
//  NewsApp
//
//  Created by Atakan Atalar on 26.10.2024.
//

import UIKit
import Toast

class FavoritesViewController: NADataLoadingViewController {
    private let viewModel = FavoritesViewModel()
    private let tableView = UITableView()
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    
    var router: FavoritesRouter
    
    init(router: FavoritesRouter) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        title = FavoritesViewConstants.title
        
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
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: FavoritesViewConstants.tableViewCellID)
    }
    
    private func loadFavorites() {
        viewModel.loadFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                self.updateUI(with: favorites)
            case .failure(let error):
                let toast = Toast.default(
                    image: UIImage(systemName: SFSymbolsConstants.error)!,
                    title: ToastConstants.errorTitle,
                    subtitle: error.localizedDescription
                )
                toast.show(haptic: .error, after: 0)
            }
        }
    }
    
    func updateUI(with favoriteArticles: [Article]) {
        if favoriteArticles.isEmpty {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.showEmptyStateView(with: FavoritesViewConstants.emptyStateMessage, in: self.view)
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
        return viewModel.favoriteArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesViewConstants.tableViewCellID, for: indexPath) as! NewsTableViewCell
        let article = viewModel.favoriteArticles[indexPath.row]
        cell.configure(with: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = viewModel.favoriteArticles[indexPath.row]
        router.pushDetailViewController(article: selectedArticle)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeFavorite(at: indexPath.row) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .left)
                        self.feedbackGenerator.notificationOccurred(.success)
                        self.loadFavorites()
                    }
                case .failure(let error):
                    let toast = Toast.default(
                        image: UIImage(systemName: SFSymbolsConstants.error)!,
                        title: ToastConstants.errorTitle,
                        subtitle: error.localizedDescription
                    )
                    toast.show(haptic: .error, after: 0)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CellHeightHelper.heightForRow()
    }
}
