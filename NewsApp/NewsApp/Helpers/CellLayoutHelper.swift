//
//  LayoutHelper.swift
//  NewsApp
//
//  Created by Atakan Atalar on 14.11.2024.
//

import UIKit

struct CellLayoutHelper {
    static func updateLayoutConstraints(for cell: NewsTableViewCell) {
        let contentSizeCategory = UIApplication.shared.preferredContentSizeCategory
        let isAccessibilityLayout = contentSizeCategory >= .accessibilityMedium
        
        if isAccessibilityLayout {
            NSLayoutConstraint.deactivate(cell.regularConstraints)
            NSLayoutConstraint.activate(cell.accessibilityConstraints)
        } else {
            NSLayoutConstraint.deactivate(cell.accessibilityConstraints)
            NSLayoutConstraint.activate(cell.regularConstraints)
        }
        cell.setNeedsLayout()
    }
}
