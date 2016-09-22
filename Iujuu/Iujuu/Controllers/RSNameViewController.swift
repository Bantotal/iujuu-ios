//
//  RSNameViewController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 9/21/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class RSNameViewController: BaseRegaloSetupController {

    @IBOutlet weak var nameField: SkyFloatingLabelTextField!
    private var fieldWasTouched = false

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(nextTapped)

        nameField.textColor = textColor
        nameField.lineColor = textColor.withAlphaComponent(0.38)
        nameField.font = UIFont.bold(size: 29)

        if let name = regalo.name {
            nameField.text = name
        }

        nameField.titleLabel.font = UIFont.regular(size: 18)
        nameField.titleColor = textColor.withAlphaComponent(0.38)
        nameField.placeholder = NSLocalizedString("\(regalo.motivo ?? "") de", comment: "")
        nameField.placeholderColor = textColor
        nameField.selectedLineColor = textColor
        nameField.selectedTitleColor = textColor
        nameField.titleFormatter = { return $0 }
        nameField.errorColor = .red

        nameField.rx.text.asObservable().do(onNext: { [weak self] text in
            if text.isEmpty {
                if self?.fieldWasTouched == true {
                    self?.nameField.errorMessage = "El nombre no puede ser vacío"
                }
            } else {
                self?.fieldWasTouched = true
                self?.nameField.errorMessage = nil
            }
            self?.regalo.name = text
        }).subscribe().addDisposableTo(disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProgressBarPercentage(page: 2)
        _ = nameField.becomeFirstResponder()
    }

    func nextTapped() {
        if nameField.text?.isEmpty == false {
            _ = nameField.resignFirstResponder()
            regalo.name = nameField.text
            performSegue(withIdentifier: R.segue.rSNameViewController.pushToCloseDate.identifier, sender: self)
        } else {
            nameField.errorMessage = "El nombre no puede ser vacío"
        }
    }

}
