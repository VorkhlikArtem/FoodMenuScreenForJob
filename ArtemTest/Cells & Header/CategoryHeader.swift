//
//  MealCell.swift
//  ArtemTest
//
//  Created by Артём on 03.04.2023.
//

import UIKit
import Combine

class CategoryHeader: UICollectionReusableView {
    static var reuseId: String = "CategoryHeader"
    
    private var initiallySelectedIndex = 0
    
    private let buttonSubject = PassthroughSubject<Int, Never>()
    var buttonPublisher: AnyPublisher<Int, Never> {
        buttonSubject.removeDuplicates().eraseToAnyPublisher()
    }
    var cancellables = Set<AnyCancellable>()
    
    let scrollView = UIScrollView()
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        scrollView.showsHorizontalScrollIndicator = false
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup with content
    func setup(with categoryViewModels: [CategoryViewModel]) {
        stackView.arrangedSubviews.forEach{
            stackView.removeArrangedSubview($0)
        }
        stackView.arrangedSubviews.forEach{$0.removeFromSuperview()}
        
        categoryViewModels.enumerated().forEach { index, category in
            let button = generateButton(with: category.category, index: index)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func generateButton(with text: String, index: Int) -> UIButton {
        let button = CapsuleButton(type: .system)
        button.setTitle(text, for: .normal)
        
        if index == initiallySelectedIndex {
            button.selectButton()
        } else {
            button.unselectButton()
        }
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }
    
    @objc private func buttonTapped(selectedButton: CapsuleButton) {
        for button in stackView.arrangedSubviews {
            guard let button = button as? CapsuleButton else {return}
            button.unselectButton()
        }
        selectedButton.selectButton()
        
        if let index = stackView.arrangedSubviews.firstIndex(of: selectedButton) {
            buttonSubject.send(index)
        }
    }
    
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
    }

}
