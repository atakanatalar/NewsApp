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
    
    var selectedCategory: NewsCategory = .general
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        title = "News App"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", image: nil, primaryAction: nil, menu: createCategoryMenu())
        
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
        
        let endpoint = NewsAPIEndpoint.topHeadlines(category: category)
        
        networkManager.request(endpoint: endpoint) { [weak self] (result: Result<NewsResponse, NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let newsResponse):
                self.articles = newsResponse.articles
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchNews() {
        let endpoint = NewsAPIEndpoint.topHeadlines(category: .general)
        
        networkManager.request(endpoint: endpoint) { [weak self] (result: Result<NewsResponse, NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let newsResponse):
                self.articles = newsResponse.articles
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let article = articles[indexPath.row]
        cell.textLabel?.text = article.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = articles[indexPath.row]
        print(selectedArticle.title ?? "selected")
    }
}
