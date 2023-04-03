//
//  MealCell.swift
//  ArtemTest
//
//  Created by Артём on 03.04.2023.
//

import UIKit

class MealCell: UICollectionViewCell {
    static var reuseId: String = "MealCell"
    
    let productImageView = WebImageView()
    let nameLabel = UILabel(font: .systemFont(ofSize: 17), textColor: #colorLiteral(red: 0.1340610683, green: 0.1581320465, blue: 0.1931300461, alpha: 1))
    let descriptionLabel = UILabel(font: .systemFont(ofSize: 13), textColor: #colorLiteral(red: 0.6664914489, green: 0.6673851013, blue: 0.6775504351, alpha: 1))
    lazy var priceLabel: CustomLabel = {
        let label = CustomLabel()
        label.textInsets = UIEdgeInsets(top: 8, left: 18, bottom: 8, right: 18)
        label.font = .systemFont(ofSize: 13)
        label.textColor = .pink
        label.layer.cornerRadius = 6
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.pink.cgColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        backgroundColor = .white
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        descriptionLabel.numberOfLines = 0
        
        clipsToBounds = true
        layer.cornerRadius = 15
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
    }
    
    func configure(with mealViewModel: MealViewModel) {
        productImageView.set(imageURL: mealViewModel.image)
        nameLabel.text = mealViewModel.name
        descriptionLabel.text = mealViewModel.description
        priceLabel.text = "from 3 $"
    }
    
    private func setupConstraints() {
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let priceStack = UIStackView(arrangedSubviews: [spacer, priceLabel])
        priceStack.axis = .horizontal
        
        let vStack = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, priceStack])
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.setCustomSpacing(25, after: descriptionLabel)
        descriptionLabel.setContentHuggingPriority(.required, for: .vertical)
        
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalToConstant: 130),
            productImageView.widthAnchor.constraint(equalToConstant: 130),
        ])
        productImageView.layer.cornerRadius = 130/2
        
        let hStack = UIStackView(arrangedSubviews: [productImageView, vStack])
        hStack.axis = .horizontal
        hStack.spacing = 30
        hStack.alignment = .top
        
        hStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
        
        let separator = UIView()
        separator.backgroundColor = #colorLiteral(red: 0.9540367723, green: 0.961568892, blue: 0.978757441, alpha: 1)
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
