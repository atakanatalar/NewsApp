//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Atakan Atalar on 19.10.2024.
//

import UIKit
import SafariServices
import Toast
import TipKit

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
    private let moreDetailButton = NAButton(title: DetailViewConstants.moreDetailButtonTitle, systemImageName: SFSymbolsConstants.safari)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    private var addFavoriteTip = AddFavoritesTip()
    private var aspectRatioConstraint: NSLayoutConstraint?
    private var sourceAndDateHorizontalConstraints: [NSLayoutConstraint] = []
    private var sourceAndDateVerticalConstraints: [NSLayoutConstraint] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        setupUI()
        configureView()
        incrementAppOpenCount()
        
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleContentSizeCategoryChange),
                name: UIContentSizeCategory.didChangeNotification,
                object: nil
            )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAddFavoriteTip()
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
            
            detailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -50),
            detailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
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
        
        sourceAndDateHorizontalConstraints = [
            sourceLabel.topAnchor.constraint(equalTo: detailImageView.bottomAnchor, constant: 10),
            sourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            dateLabel.topAnchor.constraint(equalTo: detailImageView.bottomAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ]
        
        sourceAndDateVerticalConstraints = [
            sourceLabel.topAnchor.constraint(equalTo: detailImageView.bottomAnchor, constant: 10),
            sourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            dateLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(sourceAndDateHorizontalConstraints)
        
        moreDetailButton.addTarget(self, action: #selector(moreDetailsButtonTapped), for: .touchUpInside)
        setupFavoriteButton()
    }
    
    @objc private func handleContentSizeCategoryChange() {
        adjustLabelConstraints()
    }
    
    private func adjustLabelConstraints() {
        let contentSizeCategory = UIApplication.shared.preferredContentSizeCategory
        
        if contentSizeCategory >= .accessibilityMedium {
            NSLayoutConstraint.deactivate(sourceAndDateHorizontalConstraints)
            NSLayoutConstraint.activate(sourceAndDateVerticalConstraints)
        } else {
            NSLayoutConstraint.deactivate(sourceAndDateVerticalConstraints)
            NSLayoutConstraint.activate(sourceAndDateHorizontalConstraints)
        }
        view.layoutIfNeeded()
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
            detailImageView.sd_setImage(with: url, placeholderImage: placeholderImage) { [weak self] image, _, _, _ in
                guard let self = self, let image = image else { return }
                self.updateImageAspectRatio(image: image)
            }
        } else {
            let defaultImage = viewModel.getDefaultImage()
            detailImageView.image = defaultImage
            updateImageAspectRatio(image: defaultImage)
        }
        
        updateFavoriteButtonState()
    }
    
    private func updateImageAspectRatio(image: UIImage) {
        if let existingConstraint = aspectRatioConstraint {
            detailImageView.removeConstraint(existingConstraint)
        }
        
        let aspectRatio = image.size.width / image.size.height
        aspectRatioConstraint = detailImageView.widthAnchor.constraint(equalTo: detailImageView.heightAnchor, multiplier: aspectRatio)
        aspectRatioConstraint?.isActive = true
    }
    
    private func setupFavoriteButton() {
        favoriteButton.target = self
        favoriteButton.action = #selector(toggleFavorite)
        navigationItem.rightBarButtonItem = favoriteButton
        updateFavoriteButtonState()
    }
    
    private func updateFavoriteButtonState() {
        favoriteButton.image = UIImage(systemName: viewModel?.favoriteIconName ?? SFSymbolsConstants.bookmark)
    }
    
    private func showAddFavoriteTip() {
        Task {
            if #available(iOS 17.0, *) {
                for await shouldDisplay in addFavoriteTip.shouldDisplayUpdates {
                    if shouldDisplay {
                        let controller = TipUIPopoverViewController(addFavoriteTip, sourceItem: favoriteButton)
                        present(controller, animated: true)
                    } else if presentedViewController is TipUIPopoverViewController {
                        dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    private func incrementAppOpenCount() {
        Task {
            if #available(iOS 17.0, *) {
                await AddFavoritesTip.appOpenedCount.donate()
            }
        }
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
                        image: UIImage(systemName: SFSymbolsConstants.error)!,
                        title: ToastConstants.errorTitle,
                        subtitle: error.localizedDescription
                    )
                    toast.show(haptic: .error, after: 0)
                }
                
                if #available(iOS 17.0, *) { self?.addFavoriteTip.invalidate(reason: .tipClosed) }
            }
        }
    }
    
    @objc private func moreDetailsButtonTapped() {
        guard let articleURLString = viewModel?.articleURL, let url = URL(string: articleURLString) else {
            let toast = Toast.default(
                image: UIImage(systemName: SFSymbolsConstants.error)!,
                title: ToastConstants.errorTitle,
                subtitle: DetailViewConstants.moreDetailErrorMessage
            )
            toast.show(haptic: .error, after: 0)
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
}

#Preview {
    let vc = DetailViewController()
    vc.article = Article.mock
    return UINavigationController(rootViewController: vc)
}
