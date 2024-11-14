//
//  CellHeightHelper.swift
//  NewsApp
//
//  Created by Atakan Atalar on 14.11.2024.
//

import Foundation
import UIKit

struct CellHeightHelper {
    static func heightForRow() -> CGFloat {
        let contentSizeCategory = UIApplication.shared.preferredContentSizeCategory
        
        switch contentSizeCategory {
        case .accessibilityMedium:
            return 418
        case .accessibilityLarge:
            return 484
        case .accessibilityExtraLarge:
            return 585
        case .accessibilityExtraExtraLarge:
            return 708
        case .accessibilityExtraExtraExtraLarge:
            return 814
        default:
            return 120
        }
    }
}
