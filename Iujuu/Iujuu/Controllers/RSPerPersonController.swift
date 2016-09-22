//
//  RSPerPersonController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class RSPerPersonViewController: BaseRegaloSetupController {

    @IBOutlet weak var perPersonField: SkyFloatingLabelTextField!
    @IBOutlet weak var helpLabel: UILabel!
    private var fieldWasTouched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(nextTapped)

        perPersonField.textColor = textColor
        perPersonField.lineColor = textColor.withAlphaComponent(0.38)
        perPersonField.font = UIFont.bold(size: 29)
        perPersonField.placeholderFont = UIFont.bold(size: 24)
        perPersonField.adjustsFontSizeToFitWidth = true
        perPersonField.minimumFontSize = 22

        if let amount = regalo.suggestedPerPerson {
            perPersonField.text = formatter.string(from: NSNumber(value: amount))
        }

        perPersonField.titleLabel.font = UIFont.regular(size: 18)
        perPersonField.titleColor = textColor.withAlphaComponent(0.38)
        perPersonField.placeholder = NSLocalizedString("Monto sugerido por persona", comment: "")
        perPersonField.placeholderColor = textColor
        perPersonField.selectedLineColor = textColor
        perPersonField.selectedTitleColor = textColor
        perPersonField.titleFormatter = { return $0 }
        perPersonField.errorColor = .red
        perPersonField.keyboardType = .numberPad

        perPersonField.rx.text.asObservable().do(onNext: { [weak self] text in
            guard let me = self else { return }
            if text.isEmpty {
                if self?.fieldWasTouched == true {
                    self?.perPersonField.errorMessage = "El monto sugerido no puede ser vacío"
                }
            } else {
                self?.fieldWasTouched = true
                self?.perPersonField.errorMessage = nil
                if let amount = me.formatter.number(from: text)?.intValue {
                    me.regalo.suggestedPerPerson = amount
                }
            }

            // format currency number
            me.reformatCurrencyNumber(textField: me.perPersonField)
            }).subscribe().addDisposableTo(disposeBag)

        helpLabel.text = NSLocalizedString("Los participantes podrán aportar cualquier cifra", comment: "")
        helpLabel.textColor = textColor
        helpLabel.font = UIFont.regular(size: 14)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProgressBarPercentage(page: 5)
        _ = perPersonField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        regalo.name = perPersonField.text
    }

    func nextTapped() {
        if let perPersonText = perPersonField.text, let perPersonAmount = formatter.number(from: perPersonText)?.intValue {
            _ = perPersonField.resignFirstResponder()
            regalo.suggestedPerPerson = perPersonAmount
            performSegue(withIdentifier: R.segue.rSAmountViewController.showPerPersonSuggestion.identifier, sender: self)
        } else {
            perPersonField.errorMessage = "El monto sugerido no puede ser vacío"
        }
    }

}
