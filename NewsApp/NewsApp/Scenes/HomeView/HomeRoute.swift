//
//  HomeRoute.swift
//  NewsApp
//
//  Created by Atakan Atalar on 21.11.2024.
//

import UIKit

protocol HomeRoute {
    func placeOnHomeViewController()
}

extension HomeRoute where Self: RouterProtocol {
    func placeOnHomeViewController() {
        let router = HomeRouter()
        let homeViewController = HomeViewController(router: router)
        let navigationController = UINavigationController(rootViewController: homeViewController)
        let transition = PlaceOnWindowTransition()
        router.presentingViewController = homeViewController
        
        open(navigationController, transition: transition)
    }
}
