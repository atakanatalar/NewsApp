//
//  CellContentSizeHelper.swift
//  NewsApp
//
//  Created by Atakan Atalar on 14.11.2024.
//

import UIKit

struct CellContentSizeHelper {
    static func determineTitleLabelNumberOfLines() -> Int {
        let contentSizeCategory = UIApplication.shared.preferredContentSizeCategory
        
        if contentSizeCategory >= .extraLarge && contentSizeCategory < .accessibilityMedium {
            return 2
        } else {
            return 3
        }
    }
}

