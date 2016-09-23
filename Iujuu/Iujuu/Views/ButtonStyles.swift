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
    case primaryWith(color: UIColor) /* .custom */
    case secondary(borderColor: UIColor) /* .custom */
    case border(borderColor: UIColor) /* .system */
    case borderless(titleColor: UIColor) /* .system */

}

extension UIButton {

    func setStyle(_ style: IujuuButtonStyle) {
        switch style {
        case .primary:
            setupBackground(color: .ijMainOrangeColor())
            setupFixedTitle(color: .white)
            titleLabel?.font = .bold(size: 20)
        case let .primaryWith(color):
            setupBackground(color: color)
            setupFixedTitle(color: .white)
            titleLabel?.font = .bold(size: 20)
        case let .secondary(borderColor):
            setupBackground(color: .white)
            layer.borderWidth = 0.8
            layer.borderColor = borderColor.cgColor
            setupFixedTitle(color: .black)
            titleLabel?.font = .regular(size: 20)
        case let .border(borderColor):
            backgroundColor = .clear
            layer.borderWidth = 3
            layer.borderColor = borderColor.cgColor
            setTitleColor(borderColor, for: .normal)
            titleLabel?.font = .regular(size: 20)
        case let .borderless(titleColor):
            backgroundColor = .clear
            setTitleColor(titleColor, for: .normal)
            titleLabel?.font = .bold(size: 20)
        }
        layer.cornerRadius = 12
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
