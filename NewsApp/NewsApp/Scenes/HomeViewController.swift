//
//  ViewController.swift
//  NewsApp
//
//  Created by Atakan Atalar on 18.10.2024.
//

import UIKit

class HomeViewController: UIViewController {
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        title = "News App"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchNews()
    }
    
    func fetchNews() {
        let endpoint = NewsAPIEndpoint.topHeadlines(category: .all)
//        let endpoint = NewsAPIEndpoint.everything(query: "bitcoin")
        
        networkManager.request(endpoint: endpoint) { (result: Result<NewsResponse, NetworkError>) in
            switch result {
            case .success(let newsResponse):
                print(newsResponse.articles)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
