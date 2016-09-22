//
//  BaseRegaloSetupController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit

struct RegaloSetup {
    var motivo: String?
    var name: String?
    var closingDate: Date?
    var amount: Int?
    var peopleCount: Int?
    var suggestedPerPerson: Int?
}

class BaseRegaloSetupController: XLViewController {

    var regalo: RegaloSetup!
    var textColor = UIColor.white

    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        formatter.locale = Locale(identifier: "es_AR")
        return formatter
    }()

    fileprivate var backgroundColor = UIColor(red: 232.0 / 255.0, green: 123.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.backgroundColor = backgroundColor
    }

    func setupNavigationBar() {
        navigationItem.rightBarButtonItem?.title = "Siguiente"
        navigationItem.backBarButtonItem?.title = "Atrás"
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = backgroundColor
        navigationController?.navigationBar.tintColor = textColor

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        (segue.destination as? BaseRegaloSetupController)?.regalo = regalo
    }

    func setProgressBarPercentage(page: Int) {
        (navigationController as? IURegaloNavigationController)?.progressView.setProgress(percentage: page, of: 6)
    }
}

extension BaseRegaloSetupController {

    func reformatCurrencyNumber(textField: UITextField) {
        guard let selectedRange = textField.selectedTextRange, let textString = textField.text else { return }
        var targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
        let digitString = removeNonDigits(string: textString, cursorPosition: &targetCursorPosition)

        if let amount = Int(digitString) {
            textField.text = formatter.string(from: NSNumber(value: amount))
        } else {
            textField.text = formatter.string(from: 0)
            return
        }

        targetCursorPosition += 2 + Int(targetCursorPosition / 3)
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
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
