//
//  LoginRoute.swift
//  NewsApp
//
//  Created by Atakan Atalar on 21.11.2024.
//

import UIKit

protocol OnboardRoute {
    func placeOnOnboardViewController()
}

extension OnboardRoute where Self: RouterProtocol {
    func placeOnOnboardViewController() {
        let router = OnboardRouter()
        let onboardViewController = OnboardingViewController(router: router)
        let navigationController = UINavigationController(rootViewController: onboardViewController)
        let transition = PlaceOnWindowTransition()
        router.presentingViewController = onboardViewController
        
        open(navigationController, transition: transition)
    }
}
