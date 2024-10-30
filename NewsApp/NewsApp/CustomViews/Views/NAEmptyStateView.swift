//
//  NAEmptyStateView.swift
//  NewsApp
//
//  Created by Atakan Atalar on 29.10.2024.
//

import UIKit

class NAEmptyStateView: UIView {
    let messageLabel = NATitleLabel(textStyle: .title1, fontWeight: .bold, textColor: .secondaryLabel)
    let logoImageView = NAImageView(contentMode: .scaleAspectFit)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureMessageLabel()
        configureLogoImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    func configureMessageLabel() {
        addSubview(messageLabel)
        messageLabel.numberOfLines = 3
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func configureLogoImageView() {
        addSubview(logoImageView)
        logoImageView.image = UIImage(systemName: "newspaper")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.tintColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 140),
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 80),
        ])
    }
}
