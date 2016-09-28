//
//  Eureka.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/23/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import Eureka

extension Section {

    func setEmptyFooterOfHeight(height: CGFloat, width: CGFloat = UIScreen.main.bounds.size.width) {
        self.footer = HeaderFooterView<UIView>(HeaderFooterProvider.callback {
            return UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        })
        self.footer?.height = { height }
    }

    func setEmptyHeaderOfHeight(height: CGFloat, width: CGFloat = UIScreen.main.bounds.size.width) {
        self.header = HeaderFooterView<UIView>(HeaderFooterProvider.callback {
            return UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        })
        self.header?.height = { height }
    }

}

public struct RulePasswordIsValid<T: Equatable>: RuleType {

    public init(){}

    public var id: String?
    public var validationError = ValidationError(msg: UserMessages.Register.passwordInvalid)

    public func isValid(value: T?) -> ValidationError? {
        if let str = value as? String {
            let passwordValidator = DefaultPasswordValidator()
            return passwordValidator.isPasswordValid(str) ? nil : validationError
        }
        return value != nil ? nil : validationError
    }
}
