//
//  CurrencyIntRow.swift
//  Iujuu
//
//  Created by Mathias Claassen on 10/6/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import Eureka

class CurrencyIntCell: IntCell {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if let value = Constants.Formatters.intCurrencyFormatter.number(from: text.replacingOccurrences(of: ".", with: "")) {
                row.value = value.intValue
            }
        }
        textField.reformatCurrencyNumber()
    }

}

final class CurrencyIntRow: FieldRow<CurrencyIntCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        formatter = Constants.Formatters.intCurrencyFormatter
        useFormatterDuringInput = true
    }
}
