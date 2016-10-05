//
//  InsertCodeController.swift
//  Iujuu
//
//  Created by Mathias Claassen on 10/4/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class RSInsertCodeViewController: BaseRegaloSetupController {

    @IBOutlet weak var codeField: SkyFloatingLabelTextField!
    private var fieldWasTouched = false

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(nextTapped)

        setup(textField: codeField)

        codeField.rx.text.asObservable().do(onNext: { [weak self] text in
            if text.characters.count != 5 {
                if self?.fieldWasTouched == true {
                    self?.codeField.errorMessage = UserMessages.InsertCode.errorMessage
                }
            } else {
                self?.codeField.errorMessage = nil
            }
            if !text.isEmpty {
                self?.fieldWasTouched = true
            }
            self?.regalo.descripcion = text
            }).subscribe().addDisposableTo(disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addGestureRecognizerToView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = codeField.becomeFirstResponder()
    }

    override func setup(textField: SkyFloatingLabelTextField) {
        super.setup(textField: textField)
        codeField.autocorrectionType = .no
        codeField.autocapitalizationType = .allCharacters
        codeField.text = UserMessages.InsertCode.textTitle
    }

    func nextTapped() {
        if codeField.text?.characters.count == 5 {

            _ = codeField.resignFirstResponder()
            regalo.descripcion = codeField.text
            performSegue(withIdentifier: R.segue.rSNameViewController.pushToCloseDate.identifier, sender: self)
        } else {
            codeField.errorMessage = UserMessages.InsertCode.errorMessage
        }
    }

}

extension UserMessages.InsertCode {
    static let errorMessage = NSLocalizedString("Por favor ingrese un código de 5 dígitos o letras.", comment: "")
    static let textTitle = NSLocalizedString("Código de Colecta", comment: "")
}
