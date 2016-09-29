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

        setup(textField: nameField)
        if let name = regalo.name {
            nameField.text = name
        }

        nameField.rx.text.asObservable().do(onNext: { [weak self] text in
            if text.isEmpty {
                if self?.fieldWasTouched == true {
                    self?.nameField.errorMessage = UserMessages.RegalosSetup.nameError
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
        setProgressBarPercentage(page: 3)
        addGestureRecognizerToView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = nameField.becomeFirstResponder()
    }

    override func setup(textField: SkyFloatingLabelTextField) {
        super.setup(textField: textField)
        nameField.autocorrectionType = .no
        nameField.autocapitalizationType = .words
        nameField.placeholder = NSLocalizedString("{0} de", comment: "").parametrize(regalo.motivo ?? "")
    }

    func nextTapped() {
        if nameField.text?.isEmpty == false {
            _ = nameField.resignFirstResponder()
            regalo.name = nameField.text
            performSegue(withIdentifier: R.segue.rSNameViewController.pushToCloseDate.identifier, sender: self)
        } else {
            nameField.errorMessage = UserMessages.RegalosSetup.nameError
        }
    }

}
