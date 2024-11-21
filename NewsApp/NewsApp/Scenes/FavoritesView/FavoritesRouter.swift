//
//  FavoritesRouter.swift
//  NewsApp
//
//  Created by Atakan Atalar on 21.11.2024.
//

import Foundation

final class FavoritesRouter: Router, FavoritesRouter.Routes {
    typealias Routes = HomeRoute & DetailRoute
}
