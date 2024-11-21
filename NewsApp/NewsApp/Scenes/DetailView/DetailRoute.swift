//
//  DetailRoute.swift
//  NewsApp
//
//  Created by Atakan Atalar on 21.11.2024.
//

import Foundation

protocol DetailRoute {
    func pushDetailViewController(article: Article)
}

extension DetailRoute where Self: RouterProtocol {
    func pushDetailViewController(article: Article) {
        let router = DetailRouter()
        let detailViewController = DetailViewController(router: router)
        let transition = PushTransition()
        router.presentingViewController = detailViewController
        detailViewController.article = article
        
        open(detailViewController, transition: transition)
    }
}
