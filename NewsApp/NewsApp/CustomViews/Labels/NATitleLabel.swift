//
//  NATitleLabel.swift
//  NewsApp
//
//  Created by Atakan Atalar on 29.10.2024.
//

import UIKit

class NATitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(
        textAlignment: NSTextAlignment = .center,
        textStyle: UIFont.TextStyle,
        fontWeight: UIFont.Weight,
        textColor: UIColor = .label
    ) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        let customDescriptor = descriptor.addingAttributes([
            .traits: [UIFontDescriptor.TraitKey.weight: fontWeight]
        ])
        let customFont = UIFont(descriptor: customDescriptor, size: descriptor.pointSize)
        self.font = UIFontMetrics.default.scaledFont(for: customFont)
        
        self.textColor = textColor
    }
    
    private func configure() {
        lineBreakMode = .byTruncatingTail
        numberOfLines = 0
        adjustsFontForContentSizeCategory = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
