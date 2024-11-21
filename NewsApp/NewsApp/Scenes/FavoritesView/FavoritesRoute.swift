//
//  FavoritesRoute.swift
//  NewsApp
//
//  Created by Atakan Atalar on 21.11.2024.
//

import Foundation

protocol FavoritesRoute {
    func pushFavoritesViewController()
}

extension FavoritesRoute where Self: RouterProtocol {
    func pushFavoritesViewController() {
        let router = FavoritesRouter()
        let favoritesViewController = FavoritesViewController(router: router)
        let transition = PushTransition()
        router.presentingViewController = favoritesViewController
        
        open(favoritesViewController, transition: transition)
    }
}
