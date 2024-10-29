//
//  NABodyLabel.swift
//  NewsApp
//
//  Created by Atakan Atalar on 29.10.2024.
//

import UIKit

class NABodyLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(
        textAlignment: NSTextAlignment = .left,
        textStyle: UIFont.TextStyle,
        textColor: UIColor = .label
    ) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.preferredFont(forTextStyle: textStyle)
        self.textColor = textColor
    }
    
    private func configure() {
        lineBreakMode = .byTruncatingTail
        numberOfLines = 0
        adjustsFontForContentSizeCategory = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
