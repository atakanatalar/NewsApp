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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let MoreDetailButton: UIButton = {
        let button = UIButton()
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.title = "More Detail"
        buttonConfiguration.image = UIImage(systemName: "safari")
        buttonConfiguration.imagePadding = 6
        buttonConfiguration.imagePlacement = .trailing
        buttonConfiguration.baseBackgroundColor = .secondarySystemBackground
        buttonConfiguration.baseForegroundColor = .label
        buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
        button.configuration = buttonConfiguration
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(moreDetailsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        setupUI()
        configureView()
    }
    
    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(sourceLabel)
        view.addSubview(dateLabel)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(contentLabel)
        view.addSubview(MoreDetailButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        MoreDetailButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            imageView.heightAnchor.constraint(equalToConstant: view.bounds.width * 9 / 16),
            
            sourceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            sourceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            dateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            contentLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            MoreDetailButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 20),
            MoreDetailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
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
            
            imageView.sd_setImage(with: url, placeholderImage: placeholderImage)
            imageView.tintColor = .systemGray
        } else {
            let defaultImage = UIImage(systemName: "newspaper")?.withRenderingMode(.alwaysTemplate)
            
            imageView.image = defaultImage
            imageView.tintColor = .systemGray
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
