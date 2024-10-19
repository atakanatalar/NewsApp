//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Atakan Atalar on 19.10.2024.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 3
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailsLabel)
        
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            newsImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            newsImageView.widthAnchor.constraint(equalToConstant: 90),
            newsImageView.heightAnchor.constraint(equalToConstant: 90),
            
            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: newsImageView.topAnchor),
            
            detailsLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 10),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            detailsLabel.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with article: Article) {
        titleLabel.text = article.title
        
        var dateStr = "Unknown Date"
        
        if let publishedAtString = article.publishedAt,
           let publishedAtDate = DateHelper.dateFromString(publishedAtString) {
            dateStr = DateHelper.timeAgoSinceDate(publishedAtDate)
        }
        
        if let source = article.source?.name {
            detailsLabel.text = "\(dateStr) | \(source)"
        } else {
            detailsLabel.text = "\(dateStr) | Unknown Source"
        }
        
        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            let placeholderImage = UIImage(systemName: "newspaper")?.withRenderingMode(.alwaysTemplate)
            
            newsImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
            newsImageView.tintColor = .systemGray
        } else {
            let defaultImage = UIImage(systemName: "newspaper")?.withRenderingMode(.alwaysTemplate)
            
            newsImageView.image = defaultImage
            newsImageView.tintColor = .systemGray
        }
    }
}
