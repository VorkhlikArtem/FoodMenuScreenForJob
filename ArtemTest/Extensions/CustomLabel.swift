//
//  CustomLabel.swift
//  ArtemTest
//
//  Created by Артём on 03.04.2023.
//

import UIKit

class CustomLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {didSet {invalidateIntrinsicContentSize()} }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var newTextRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        newTextRect.size.width += textInsets.left + textInsets.right
        newTextRect.size.height += textInsets.top + textInsets.bottom
        return newTextRect
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}
