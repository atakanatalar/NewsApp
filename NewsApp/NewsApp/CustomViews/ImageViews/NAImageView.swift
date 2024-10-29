//
//  NAImageView.swift
//  NewsApp
//
//  Created by Atakan Atalar on 29.10.2024.
//

import UIKit

class NAImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(
        contentMode: UIView.ContentMode,
        cornerRadius: CGFloat = 0
    ) {
        self.init(frame: .zero)
        self.contentMode = contentMode
        self.layer.cornerRadius = cornerRadius
    }
    
    func configure() {
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
