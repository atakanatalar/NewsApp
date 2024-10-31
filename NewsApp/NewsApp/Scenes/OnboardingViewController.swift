//
//  OnboardingViewController.swift
//  NewsApp
//
//  Created by Atakan Atalar on 23.10.2024.
//

import UIKit

class OnboardingViewController: UIViewController {
    private let pageControl = UIPageControl()
    private let startButton = NAButton(title: OnboardingViewConstants.startButtonTitle, systemImageName: SFSymbolsConstants.arrow)
    private var pages: [UIViewController] = []
    
    private lazy var pageViewController: UIPageViewController = {
        let pvc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pvc.dataSource = self
        pvc.delegate = self
        return pvc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupPages()
        setupUI()
    }
    
    private func setupPages() {
        let page1 = createPage(
            title: OnboardingViewConstants.firstPageTitle,
            description: OnboardingViewConstants.firstPageDescription,
            imageName: SFSymbolsConstants.newspaper
        )
        let page2 = createPage(
            title: OnboardingViewConstants.secondPageTitle,
            description: OnboardingViewConstants.secondPageDescription,
            imageName: SFSymbolsConstants.grid
        )
        let page3 = createPage(
            title: OnboardingViewConstants.thirdPageTitle,
            description: OnboardingViewConstants.thirdPageDescription,
            imageName: SFSymbolsConstants.magnifyingglass
        )
        
        pages = [page1, page2, page3]
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        
        pageControl.numberOfPages = pages.count
    }
    
    private func setupUI() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        view.addSubview(pageControl)
        pageControl.pageIndicatorTintColor = .secondaryLabel
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -40),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func createPage(title: String, description: String, imageName: String) -> UIViewController {
        let vc = UIViewController()
        let imageView = UIImageView(image: UIImage(systemName: imageName))
        let titleLabel = NATitleLabel(textStyle: .title1, fontWeight: .bold)
        let descriptionLabel = NASecondaryTitleLabel(textStyle: .title3, fontWeight: .regular)
        
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        
        titleLabel.text = title
        descriptionLabel.text = description
        
        vc.view.addSubview(titleLabel)
        vc.view.addSubview(descriptionLabel)
        vc.view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor, constant: 120),
            imageView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -40),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 40),
            descriptionLabel.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -40)
        ])
        
        return vc
    }
    
    @objc private func didTapStartButton() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        
        let homeVC = HomeViewController()
        navigationController?.setViewControllers([homeVC], animated: true)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let visibleVC = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: visibleVC) {
            pageControl.currentPage = index
        }
    }
}

#Preview {
    return OnboardingViewController()
}
