//
//  BaseRegaloSetupController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

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

    fileprivate var backgroundColor = UIColor(red: 232.0 / 255.0, green: 123.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.backgroundColor = backgroundColor
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BaseRegaloSetupController.viewTapped)))
    }

    func setupNavigationBar() {
        navigationItem.rightBarButtonItem?.title = "Siguiente"
        navigationItem.backBarButtonItem?.title = "Atrás"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = backgroundColor
        navigationController?.navigationBar.tintColor = textColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setup(textField: SkyFloatingLabelTextField) {
        // TODO: setup input accessory view for textfield 
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        (segue.destination as? BaseRegaloSetupController)?.regalo = regalo
    }

    func setProgressBarPercentage(page: Int) {
        (navigationController as? IURegaloNavigationController)?.progressView.setProgress(percentage: page, of: 6)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func viewTapped() {
        _ = view.findFirstResponder()?.resignFirstResponder()
    }
    
}

extension BaseRegaloSetupController {

    func reformatCurrencyNumber(textField: UITextField) {
        guard let selectedRange = textField.selectedTextRange, let textString = textField.text else { return }
        var targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
        let digitString = removeNonDigits(string: textString, cursorPosition: &targetCursorPosition)

        if let amount = Int(digitString) {
            textField.text = Constants.Formatters.intCurrencyFormatter.string(from: NSNumber(value: amount))
        } else {
            textField.text = Constants.Formatters.intCurrencyFormatter.string(from: 0)
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