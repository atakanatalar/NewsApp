//
//  NAButton.swift
//  NewsApp
//
//  Created by Atakan Atalar on 29.10.2024.
//

import UIKit

class NAButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, systemImageName: String) {
        self.init(frame: .zero)
        set(title: title, systemImageName: systemImageName)
    }
    
    private func configure() {
        configuration = .filled()
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.borderWidth = 1.5
        layer.cornerRadius = 20
        layer.masksToBounds = true
        updateBorderColor()
    }
    
    final func set(title: String, systemImageName: String) {
        configuration?.title = title
        configuration?.baseBackgroundColor = .secondarySystemBackground
        configuration?.baseForegroundColor = .label
        
        configuration?.image = UIImage(systemName: systemImageName)
        configuration?.imagePadding = 10
        configuration?.imagePlacement = .trailing
        
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
    }
    
    private func updateBorderColor() {
        layer.borderColor = UIColor.label.cgColor
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            updateBorderColor()
        }
    }
}
