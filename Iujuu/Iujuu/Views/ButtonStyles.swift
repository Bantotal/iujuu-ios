//
//  ButtonStyles.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import DynamicColor

enum IujuuButtonStyle {

    case primary /* .custom */
    case secondary(borderColor: UIColor) /* .custom */
    case border(borderColor: UIColor) /* .system */
    case borderless(titleColor: UIColor) /* .system */

}

extension UIButton {

    func setStyle(_ style: IujuuButtonStyle) {
        switch style {
        case .primary:
            setupBackground(color: .ijDustyOrangeColor())
            setupFixedTitle(color: .white)
        case let .secondary(borderColor):
            setupBackground(color: .white)
            layer.borderWidth = 3
            layer.borderColor = borderColor.cgColor
            setupFixedTitle(color: .black)
        case let .border(borderColor):
            backgroundColor = .clear
            layer.borderWidth = 3
            layer.borderColor = borderColor.cgColor
            setTitleColor(borderColor, for: .normal)
        case let .borderless(titleColor):
            backgroundColor = .clear
            setTitleColor(titleColor, for: .normal)
        }
        layer.cornerRadius = 16
        titleLabel?.font = .bold(size: 23) // TODO: this will depend on button style
        clipsToBounds = true
    }

    private func setupBackground(color: UIColor) {
        setBackgroundImage(UIImage(color: color), for: .normal)
        setBackgroundImage(UIImage(color: color.darkened()), for: .highlighted)
        setBackgroundImage(UIImage(color: color.lighter()), for: .disabled)
    }
    
    private func setupFixedTitle(color: UIColor) {
        setTitleColor(color, for: .normal)
        setTitleColor(color.lighter(), for: .highlighted)
        setTitleColor(color.grayscaled(), for: .disabled)
    }

}
