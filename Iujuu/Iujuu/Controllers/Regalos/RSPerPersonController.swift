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

        setup(textField: perPersonField)
        if let amount = regalo.suggestedPerPerson {
            perPersonField.text = Constants.Formatters.intCurrencyFormatter.string(from: NSNumber(value: amount))
        }

        perPersonField.rx.text.asObservable().do(onNext: { [weak self] text in
            guard let me = self else { return }
            if text.isEmpty {
                if self?.fieldWasTouched == true {
                    self?.perPersonField.errorMessage = UserMessages.RegalosSetup.perPersonError
                }
            } else {
                self?.fieldWasTouched = true
                self?.perPersonField.errorMessage = nil
                if let amount = Constants.Formatters.intCurrencyFormatter.number(from: text)?.intValue {
                    me.regalo.suggestedPerPerson = amount
                }
            }

            // format currency number
            me.reformatCurrencyNumber(textField: me.perPersonField)
            }).subscribe().addDisposableTo(disposeBag)

        helpLabel.text = UserMessages.RegalosSetup.perPersonHelp
        helpLabel.textColor = textColor
        helpLabel.font = .regular(size: 14)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProgressBarPercentage(page: 6)
        addGestureRecognizerToView()
        setupNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = perPersonField.becomeFirstResponder()
        (navigationController as? IURegaloNavigationController)?.hideProgressBar()
    }

    override func setup(textField: SkyFloatingLabelTextField) {
        super.setup(textField: textField)
        perPersonField.placeholderFont = .bold(size: 24)
        perPersonField.placeholder = UserMessages.RegalosSetup.perPersonText
        perPersonField.keyboardType = .numberPad
    }

    func nextTapped() {
        if let perPersonText = perPersonField.text, let perPersonAmount = Constants.Formatters.intCurrencyFormatter.number(from: perPersonText)?.intValue, perPersonAmount > 0 {
            _ = perPersonField.resignFirstResponder()
            regalo.suggestedPerPerson = perPersonAmount
            performSegue(withIdentifier: R.segue.rSPerPersonViewController.showConfirmRegaloView.identifier, sender: self)
        } else {
            perPersonField.errorMessage = UserMessages.RegalosSetup.perPersonError
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        (segue.destination as? RegaloPreviewViewController)?.regalo = regalo
    }

}
