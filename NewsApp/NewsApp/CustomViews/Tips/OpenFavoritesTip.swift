//
//  Tip.swift
//  NewsApp
//
//  Created by Atakan Atalar on 1.11.2024.
//

import UIKit
import TipKit

struct OpenFavoritesTip: Identifiable, Tip {
    @available(iOS 17.0, *)
    static let appOpenedCount = Event(id: OpenFavoritesTipConstants.eventID)
    
    @available(iOS 17.0, *)
    var rules: [Rule] {
        #Rule(Self.appOpenedCount) { $0.donations.count <= 3 }
    }
    
    var id = UUID()
    
    var title: Text {
        Text(OpenFavoritesTipConstants.title)
    }
    
    var message: Text? {
        Text(OpenFavoritesTipConstants.message)
    }
}
