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
import Opera
import SwiftyJSON
import Crashlytics

class RSInsertCodeViewController: BaseRegaloSetupController {

    @IBOutlet weak var codeField: SkyFloatingLabelTextField!
    private var fieldWasTouched = false
    private static let codeLength = 5

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(nextTapped)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: UserMessages.back, style: .done, target: self, action: #selector(backTapped))

        setup(textField: codeField)

        codeField.rx.text.asObservable().do(onNext: { [weak self] text in
            if text.characters.count != RSInsertCodeViewController.codeLength {
                if self?.fieldWasTouched == true {
                    self?.codeField.errorMessage = UserMessages.InsertCode.errorMessage
                }
            } else {
                self?.codeField.errorMessage = nil
            }
            if text.characters.count >= RSInsertCodeViewController.codeLength {
                self?.fieldWasTouched = true
            }
            }).subscribe().addDisposableTo(disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addGestureRecognizerToView()
        (navigationController as? IURegaloNavigationController)?.hideProgressBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = codeField.becomeFirstResponder()
    }

    override func setup(textField: SkyFloatingLabelTextField) {
        super.setup(textField: textField)
        codeField.autocorrectionType = .no
        codeField.autocapitalizationType = .allCharacters
        codeField.titleLabel.minimumScaleFactor = 0.6
        codeField.titleLabel.adjustsFontSizeToFitWidth = true
        codeField.placeholder = UserMessages.InsertCode.textTitle
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? ConfirmationCodeViewController)?.regalo = sender as? Regalo
    }

    func nextTapped() {
        if codeField.text?.characters.count == RSInsertCodeViewController.codeLength {
            LoadingIndicator.show()
            DataManager.shared.getRegalo(withCode: codeField.text!, onlyFromBackend: true).do(
                onNext: { [weak self] regalo in
                    LoadingIndicator.hide()
                    self?.performSegue(withIdentifier: R.segue.rSInsertCodeViewController.showConfirmRegalo, sender: regalo)
                },
                onError: { [weak self] error in
                    LoadingIndicator.hide()
                    self?.showError(
                        error,
                        alternative: (title: UserMessages.errorTitle, message: UserMessages.Deeplinks.regaloNotFound)
                    )
                }
            ).subscribe().addDisposableTo(disposeBag)
            _ = codeField.resignFirstResponder()
        } else {
            codeField.errorMessage = UserMessages.InsertCode.errorMessage
        }
    }

    func backTapped() {
        dismiss(animated: true, completion: nil)
    }

}

extension UserMessages.InsertCode {
    static let errorMessage = NSLocalizedString("Por favor ingrese un código de 5 dígitos o letras.", comment: "")
    static let noRegaloForCode = NSLocalizedString("No existe ningún regalo para ese código.", comment: "")
    static let textTitle = NSLocalizedString("Código de regalo", comment: "")
}
