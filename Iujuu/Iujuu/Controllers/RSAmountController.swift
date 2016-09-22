//
//  RSAmountController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class RSAmountViewController: BaseRegaloSetupController {

    @IBOutlet weak var amountField: SkyFloatingLabelTextField!
    private var fieldWasTouched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(nextTapped)

        amountField.textColor = textColor
        amountField.lineColor = textColor.withAlphaComponent(0.38)
        amountField.font = UIFont.bold(size: 29)

        if let amount = regalo.amount {
            amountField.text = formatter.string(from: NSNumber(value: amount))
        }

        amountField.titleLabel.font = UIFont.regular(size: 18)
        amountField.titleColor = textColor.withAlphaComponent(0.38)
        amountField.placeholder = NSLocalizedString("Monto objetivo", comment: "")
        amountField.placeholderColor = textColor
        amountField.selectedLineColor = textColor
        amountField.selectedTitleColor = textColor
        amountField.titleFormatter = { return $0 }
        amountField.errorColor = .red
        amountField.keyboardType = .numberPad

        amountField.rx.text.asObservable().do(onNext: { [weak self] text in
            guard let me = self else { return }
            if text.isEmpty {
                if self?.fieldWasTouched == true {
                    self?.amountField.errorMessage = "El monto no puede ser vacío"
                }
            } else {
                self?.fieldWasTouched = true
                self?.amountField.errorMessage = nil
                if let amount = me.formatter.number(from: text)?.intValue {
                    me.regalo.amount = amount
                }
            }

            // format currency number
            me.reformatCurrencyNumber(textField: me.amountField)
            }).subscribe().addDisposableTo(disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProgressBarPercentage(page: 4)
        _ = amountField.becomeFirstResponder()
    }

    func nextTapped() {
        if let amountText = amountField.text, let amount = formatter.number(from: amountText)?.intValue {
            _ = amountField.resignFirstResponder()
            regalo.amount = amount
            performSegue(withIdentifier: R.segue.rSAmountViewController.showPerPersonSuggestion.identifier, sender: self)
        } else {
            amountField.errorMessage = "El monto no puede ser vacío"
        }
    }

}
