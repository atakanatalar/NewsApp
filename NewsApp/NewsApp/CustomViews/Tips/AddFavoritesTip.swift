//
//  AddFavoritesTip.swift
//  NewsApp
//
//  Created by Atakan Atalar on 1.11.2024.
//

import UIKit
import TipKit

struct AddFavoritesTip: Identifiable, Tip {
    @available(iOS 17.0, *)
    static let appOpenedCount = Event(id: AddFavoriteTipConstants.eventID)
    
    @available(iOS 17.0, *)
    var rules: [Rule] {
        #Rule(Self.appOpenedCount) { $0.donations.count <= 3 }
    }
    
    var id = UUID()
    
    var title: Text {
        Text(AddFavoriteTipConstants.title)
    }
    
    var message: Text? {
        Text(AddFavoriteTipConstants.message)
    }
}
