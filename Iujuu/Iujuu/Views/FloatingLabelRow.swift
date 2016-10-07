//
//  FloatingLabelRow.swift
//  Iujuu
//
//  Created by user on 10/4/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import Eureka
import RxSwift
import SkyFloatingLabelTextField

public class FloatingLabelCell: Cell<Int>, CellType {

    @IBOutlet weak var amountField: SkyFloatingLabelTextField!
    let disposeBag = DisposeBag()

    var textFieldColor = UIColor.black
    var placeHolderColor = UIColor.gray
    var lineColor = UIColor.red
    var placeholderTitle = UserMessages.ParticiparRegalo.inputTitle

    private var fieldWasTouched = false

    public override func setup() {
        super.setup()
        row.value = nil

        setupField()
        amountField.rx.text.asObservable().do(onNext: { [weak self] text in
            guard let me = self else { return }
            if text.isEmpty {
                if self?.fieldWasTouched == true {
                    self?.amountField.errorMessage = UserMessages.RegalosSetup.amountError
                }
            } else {
                self?.fieldWasTouched = true
                self?.amountField.errorMessage = nil
                if let amount = Constants.Formatters.intCurrencyFormatter.number(from: text)?.intValue {
                    self?.row.value = amount
                }
            }

        me.reformatCurrencyNumber(textField: me.amountField)
        }).subscribe().addDisposableTo(disposeBag)
    }

    public override func update() {
        super.update()
    }

    func setupField() {
        amountField.textAlignment = .left
        amountField.textColor = textFieldColor
        amountField.lineColor = lineColor
        amountField.font = .regular(size: 25)
        amountField.titleLabel.font = .regular(size: 16)
        amountField.titleColor = textFieldColor.withAlphaComponent(0.48)
        amountField.placeholderColor = placeHolderColor
        amountField.selectedLineColor = lineColor
        amountField.selectedTitleColor = textFieldColor
        amountField.titleFormatter = { return $0 }
        amountField.errorColor = lineColor
        amountField.placeholder = placeholderTitle
        amountField.keyboardType = .numberPad
    }
}

//MARK: - Currency formatter

extension FloatingLabelCell {

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

    func removeNonDigits(string: String, cursorPosition: inout Int) -> String {
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

public final class FloatingLabelRow: Row<FloatingLabelCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        // We set the cellProvider to load the .xib corresponding to our cell
        cellProvider = CellProvider<FloatingLabelCell>(nibName: "FloatingLabelCell")
    }
}
