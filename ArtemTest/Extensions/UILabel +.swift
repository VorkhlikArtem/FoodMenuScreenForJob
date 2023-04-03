//
//  UILabel +.swift
//  ArtemTest
//
//  Created by Артём on 03.04.2023.
//

import UIKit

extension UILabel {
    convenience init(text: String? = nil, font: UIFont?, textColor: UIColor) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
    }
    
    convenience init(text: String? = nil, font: UIFont?, textColor: UIColor, labelColor: UIColor) {
        self.init(text: text, font: font, textColor: textColor)
        backgroundColor = labelColor
        
    }
}
