//
//  CustomSegmentedControl.swift
//  NewsApp
//
//  Created by Atakan Atalar on 21.10.2024.
//

import UIKit

class CustomSegmentedControl: UIView {
    private let scrollView = UIScrollView()
    private var buttons: [UIButton] = []
    
    var selectedSegmentIndex: Int = 0 {
        didSet {
            updateView()
        }
    }
    
    var segmentTitles: [String] = [] {
        didSet {
            setupButtons()
        }
    }
    
    var buttonTapped: ((Int) -> Void)?
    
    init(segmentTitles: [String]) {
        super.init(frame: .zero)
        self.segmentTitles = segmentTitles
        setupView()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupButtons() {
        for title in segmentTitles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            scrollView.addSubview(button)
            button.layer.cornerRadius = 16
            button.backgroundColor = .clear
        }
        updateView()
    }
    
    private func updateView() {
        var currentX: CGFloat = 16
        let buttonSpacing: CGFloat = 8
        
        for (index, button) in buttons.enumerated() {
            let buttonWidth = button.intrinsicContentSize.width + 30
            button.frame = CGRect(x: currentX, y: 0, width: buttonWidth, height: self.frame.height)
            button.setTitleColor(index == selectedSegmentIndex ? .systemBlue : .systemGray, for: .normal)
            button.backgroundColor = index == selectedSegmentIndex ? .systemBlue.withAlphaComponent(0.2) : .tertiarySystemFill
            currentX += buttonWidth + buttonSpacing
        }
        
        scrollView.contentSize = CGSize(width: currentX + 8, height: self.frame.height)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }
        selectedSegmentIndex = index
        buttonTapped?(index)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }
}
