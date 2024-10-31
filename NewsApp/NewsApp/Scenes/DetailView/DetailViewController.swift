//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Atakan Atalar on 19.10.2024.
//

import UIKit
import SafariServices
import Toast

class DetailViewController: UIViewController {
    var article: Article? {
        didSet {
            guard let article = article else { return }
            viewModel = DetailViewModel(article: article)
        }
    }
    
    private var viewModel: DetailViewModel?
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
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    
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
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        contentLabel.text = viewModel.content
        dateLabel.text = viewModel.dateText
        sourceLabel.text = viewModel.source
        
        if let url = viewModel.imageUrl {
            let placeholderImage = viewModel.getDefaultImage()
            detailImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        } else {
            detailImageView.image = viewModel.getDefaultImage()
        }
        
        updateFavoriteButtonState()
    }
    
    private func setupFavoriteButton() {
        favoriteButton.target = self
        favoriteButton.action = #selector(toggleFavorite)
        navigationItem.rightBarButtonItem = favoriteButton
        updateFavoriteButtonState()
    }
    
    private func updateFavoriteButtonState() {
        favoriteButton.image = UIImage(systemName: viewModel?.favoriteIconName ?? "bookmark")
    }
    
    @objc private func toggleFavorite() {
        viewModel?.toggleFavorite { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.updateFavoriteButtonState()
                    self?.feedbackGenerator.notificationOccurred(self?.viewModel?.isFavorite == true ? .success : .warning)
                case .failure(let error):
                    let toast = Toast.default(
                        image: UIImage(systemName: "exclamationmark.triangle.fill")!,
                        title: "Something Went Wrong",
                        subtitle: error.localizedDescription
                    )
                    toast.show(haptic: .error, after: 0)
                }
            }
        }
    }
    
    @objc private func moreDetailsButtonTapped() {
        guard let articleURLString = viewModel?.articleURL, let url = URL(string: articleURLString) else {
            let toast = Toast.default(
                image: UIImage(systemName: "exclamationmark.triangle.fill")!,
                title: "Something Went Wrong",
                subtitle: "Unable to access the relevant news"
            )
            toast.show(haptic: .error, after: 0)
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
}

#Preview {
    let vc = DetailViewController()
    vc.article = Article.mock
    return UINavigationController(rootViewController: vc)
}
