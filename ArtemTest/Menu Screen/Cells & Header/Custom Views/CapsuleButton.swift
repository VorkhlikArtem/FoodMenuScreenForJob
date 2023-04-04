//
//  CapsuleButton.swift
//  ArtemTest
//
//  Created by Артём on 04.04.2023.
//

import UIKit

class CapsuleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = frame.height/2
    }
    
    func unselectButton() {
        layer.borderColor = UIColor.pink40.cgColor
        backgroundColor = .clear
        titleLabel?.font = .systemFont(ofSize: 13)
        setTitleColor(.pink40, for: .normal)
    }
    
    func selectButton() {
        layer.borderColor = UIColor.clear.cgColor
        backgroundColor = .pink20
        titleLabel?.font = .boldSystemFont(ofSize: 13)
        setTitleColor(.pink, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
