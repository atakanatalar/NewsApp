//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Atakan Atalar on 19.10.2024.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    var article: Article?
    private let favoriteButton = UIBarButtonItem()
    private let detailImageView = NAImageView(contentMode: .scaleAspectFit)
    private let sourceLabel = NABodyLabel(textStyle: .subheadline, textColor: .secondaryLabel)
    private let dateLabel = NABodyLabel(textStyle: .subheadline, textColor: .secondaryLabel)
    private let titleLabel = NATitleLabel(textAlignment: .left, textStyle: .title2, fontWeight: .bold)
    private let descriptionLabel = NABodyLabel(textStyle: .body)
    private let contentLabel = NABodyLabel(textStyle: .body)
    private let moreDetailButton = NAButton(title: "More Detail", systemImageName: "safari")
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        setupUI()
        configureView()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        scrollView.showsVerticalScrollIndicator = false
        
        contentView.addSubview(detailImageView)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(moreDetailButton)
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: moreDetailButton.bottomAnchor),
            
            detailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            detailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailImageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            detailImageView.heightAnchor.constraint(equalToConstant: view.bounds.width * 9 / 16),
            
            sourceLabel.topAnchor.constraint(equalTo: detailImageView.bottomAnchor, constant: 10),
            sourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            dateLabel.topAnchor.constraint(equalTo: detailImageView.bottomAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contentLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            moreDetailButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 20),
            moreDetailButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        moreDetailButton.addTarget(self, action: #selector(moreDetailsButtonTapped), for: .touchUpInside)
        setupFavoriteButton()
    }
    
    private func configureView() {
        guard let article = article else { return }
        
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        contentLabel.text = article.content
        
        if let publishedAt = article.publishedAt {
            dateLabel.text = DateHelper.formatDateString(publishedAt)
        }
        
        if let source = article.source?.name {
            sourceLabel.text = source
        }
        
        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            let placeholderImage = UIImage(systemName: "newspaper")?.withRenderingMode(.alwaysTemplate)
            
            detailImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
            detailImageView.tintColor = .systemGray
        } else {
            let defaultImage = UIImage(systemName: "newspaper")?.withRenderingMode(.alwaysTemplate)
            
            detailImageView.image = defaultImage
            detailImageView.tintColor = .systemGray
        }
    }
    
    @objc private func moreDetailsButtonTapped() {
        guard let articleURLString = article?.url, let url = URL(string: articleURLString) else {
            print("Invalid URL")
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
    private func setupFavoriteButton() {
        updateFavoriteButtonState()
        favoriteButton.target = self
        favoriteButton.action = #selector(toggleFavorite)
        
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    private func updateFavoriteButtonState() {
        if let article = article, FavoriteManager.shared.isFavorite(article) {
            favoriteButton.image = UIImage(systemName: "bookmark.fill")
        } else {
            favoriteButton.image = UIImage(systemName: "bookmark")
        }
    }
    
    @objc private func toggleFavorite() {
        guard let article = article else { return }
        
        if FavoriteManager.shared.isFavorite(article) {
            FavoriteManager.shared.removeArticle(article)
        } else {
            FavoriteManager.shared.saveArticle(article)
        }
        
        updateFavoriteButtonState()
    }
}

#Preview {
    let vc = DetailViewController()
    vc.article = Article.mock
    return UINavigationController(rootViewController: vc)
}
