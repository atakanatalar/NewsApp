//
//  AppRouter.swift
//  NewsApp
//
//  Created by Atakan Atalar on 21.11.2024.
//

import Foundation

final class AppRouter: Router, AppRouter.Routes {
    typealias Routes = OnboardRoute & HomeRoute
    
    static let shared = AppRouter()
    
    func startApp() {
        let isOnboardingShown = UserDefaults.standard.bool(forKey: UserDefaultsConstants.onboardingForKey)
        
        if isOnboardingShown {
            placeOnHomeViewController()
        } else {
            placeOnOnboardViewController()
        }
    }
}
