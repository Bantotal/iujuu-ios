//
//  UIswift
//  Iujuu
//
//  Created by Mathias Claassen on 10/6/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func reformatCurrencyNumber() {
        guard let selectedRange = selectedTextRange, let textString = text else { return }
        var targetCursorPosition = offset(from: beginningOfDocument, to: selectedRange.start)
        let digitString = removeNonDigits(string: textString, cursorPosition: &targetCursorPosition)

        if let amount = Int(digitString) {
            text = Constants.Formatters.intCurrencyFormatter.string(from: NSNumber(value: amount))
        } else {
            text = Constants.Formatters.intCurrencyFormatter.string(from: 0)
            return
        }

        targetCursorPosition += 2 + Int(targetCursorPosition / 3)
        if let targetPosition = position(from: beginningOfDocument, offset: targetCursorPosition) {
            selectedTextRange = textRange(from: targetPosition, to: targetPosition)
        }
    }

    public func removeNonDigits(string: String, cursorPosition: inout Int) -> String {
        let originalCursorPosition = cursorPosition
        var digitsOnlyString = ""
        for i in 0..<string.characters.count {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if "0"..."9" ~= characterToAdd {
                digitsOnlyString.append(characterToAdd)
            } else {
                if i < originalCursorPosition {
                    cursorPosition -= 1
                }
            }
        }

        return digitsOnlyString
    }
}
