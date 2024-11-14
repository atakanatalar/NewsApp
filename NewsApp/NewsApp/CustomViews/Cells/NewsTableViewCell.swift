//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Atakan Atalar on 19.10.2024.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {
    private let titleLabel = NATitleLabel(textAlignment: .left, textStyle: .body, fontWeight: .bold)
    private let detailsLabel = NABodyLabel(textStyle: .footnote, textColor: .secondaryLabel)
    private let newsImageView = NAImageView(contentMode: .scaleAspectFill, cornerRadius: 8)
    
    var regularConstraints: [NSLayoutConstraint] = []
    var accessibilityConstraints: [NSLayoutConstraint] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleContentSizeCategoryChange),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailsLabel)
    }
    
    private func setupConstraints() {
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        regularConstraints = [
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
        ]
        
        accessibilityConstraints = [
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            newsImageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ]
        
        CellLayoutHelper.updateLayoutConstraints(for: self)
    }
    
    @objc private func handleContentSizeCategoryChange() {
        CellLayoutHelper.updateLayoutConstraints(for: self)
    }
    
    func configure(with article: Article) {
        titleLabel.text = article.title
        titleLabel.numberOfLines = CellContentSizeHelper.determineTitleLabelNumberOfLines()
        detailsLabel.numberOfLines = 1
        
        var dateStr = NewsTableViewCellConstants.unknownDateLabel
        
        if let publishedAtString = article.publishedAt,
           let publishedAtDate = DateHelper.dateFromString(publishedAtString) {
            dateStr = DateHelper.timeAgoSinceDate(publishedAtDate)
        }
        
        if let source = article.source?.name {
            detailsLabel.text = "\(dateStr) | \(source)"
        } else {
            detailsLabel.text = "\(dateStr) | \(NewsTableViewCellConstants.unknownSourceLabel)"
        }
        
        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            let placeholderImage = UIImage(systemName: SFSymbolsConstants.newspaper)?.withRenderingMode(.alwaysTemplate)
            
            newsImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
            newsImageView.tintColor = .systemGray
        } else {
            let defaultImage = UIImage(systemName: SFSymbolsConstants.newspaper)?.withRenderingMode(.alwaysTemplate)
            
            newsImageView.image = defaultImage
            newsImageView.tintColor = .systemGray
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
}
