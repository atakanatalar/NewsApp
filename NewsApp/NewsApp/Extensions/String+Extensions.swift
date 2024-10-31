//
//  String+Extensions.swift
//  NewsApp
//
//  Created by Atakan Atalar on 31.10.2024.
//

import Foundation

extension String {
    static func localized(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
