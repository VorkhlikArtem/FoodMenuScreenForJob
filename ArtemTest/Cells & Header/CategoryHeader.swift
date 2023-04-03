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
    
    private var selectedIndex = 0
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
        setupConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for button in stackView.arrangedSubviews {
            guard let button = button as? UIButton else {return}
            button.clipsToBounds = true
            button.layer.cornerRadius = button.frame.height/2
        }
    }
    

    func setup(with categoryModels: [Category]) {
        stackView.arrangedSubviews.forEach{
            stackView.removeArrangedSubview($0)
        }
        stackView.arrangedSubviews.forEach{$0.removeFromSuperview()}
        categoryModels.enumerated().forEach { index, category in
            let button = generateButton(with: category.strCategory, index: index)
            stackView.addArrangedSubview(button)
        }
        layoutIfNeeded()
    }
    
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
    
    private func generateButton(with text: String, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.layer.borderWidth = 1
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        if index == selectedIndex {
            selectButton(button: button)
        } else {
            unselectButton(button: button)
        }
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }
    
    @objc private func buttonTapped(selectedButton: UIButton) {
        for button in stackView.arrangedSubviews {
            guard let button = button as? UIButton else {return}
            unselectButton(button: button)
        }
        selectButton(button: selectedButton)
        
        if let index = stackView.arrangedSubviews.firstIndex(of: selectedButton) {
            buttonSubject.send(index)
        }
    }
    
    private func unselectButton(button: UIButton) {
        button.layer.borderColor = UIColor.pink40.cgColor
        button.backgroundColor = .clear
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.setTitleColor(.pink40, for: .normal)
    }
    
    private func selectButton(button: UIButton) {
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = .pink20
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.setTitleColor(.pink, for: .normal)
    }
}
