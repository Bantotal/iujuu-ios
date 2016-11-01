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

        setup(textField: amountField)
        if let amount = regalo.amount {
            amountField.text = Constants.Formatters.intCurrencyFormatter.string(from: NSNumber(value: amount))
        }

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
                    me.regalo.amount = amount
                }
            }

            // format currency number
            me.amountField.reformatCurrencyNumber()
            }).subscribe().addDisposableTo(disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProgressBarPercentage(page: 5)
        addGestureRecognizerToView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = amountField.becomeFirstResponder()
    }

    override func setup(textField: SkyFloatingLabelTextField) {
        super.setup(textField: textField)
        amountField.placeholder = UserMessages.RegalosSetup.amountText
        amountField.keyboardType = .numberPad
    }

    func nextTapped() {
        if let amountText = amountField.text, let amount = Constants.Formatters.intCurrencyFormatter.number(from: amountText)?.intValue, amount > 0 {
            _ = amountField.resignFirstResponder()
            regalo.amount = amount
            performSegue(withIdentifier: R.segue.rSAmountViewController.showPerPersonSuggestion.identifier, sender: self)
        } else {
            amountField.errorMessage = UserMessages.RegalosSetup.amountError
        }
    }

}
