//
//  HomeRouter.swift
//  NewsApp
//
//  Created by Atakan Atalar on 21.11.2024.
//

import Foundation

final class HomeRouter: Router, HomeRouter.Routes {
    typealias Routes = DetailRoute & FavoritesRoute
}
