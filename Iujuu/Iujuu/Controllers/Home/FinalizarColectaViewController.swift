//
//  FinalizarColectaViewController.swift
//  Iujuu
//
//  Created by user on 10/10/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit
import XLSwiftKit
import Eureka
import RxSwift
import Opera

private struct finalizarRowTags {

    static let emailTag = "email tag"

}

class FinalizarColectaViewController: FormViewController {

    let disposeBag = DisposeBag()
    var regalo: Regalo!
    var enviarButton: ButtonFooter? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStyles()
        setHeader()
        setRows()
        setButton()
    }

    private func setUpStyles() {
        view.backgroundColor = .ijWhiteColor()
        tableView?.backgroundColor = .ijWhiteColor()
        tableView?.backgroundView = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = UserMessages.FinalizarColecta.title
    }

    private func setHeader() {
        let finalizarHeader = FinalizarColectaHeader(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 520))
        finalizarHeader.setRegaloInfo(regaloToShow: regalo)
        tableView?.tableHeaderView = finalizarHeader
    }

    private func setRows() {
        form +++ Section()

        <<< EmailRow(finalizarRowTags.emailTag) {
            $0.validationOptions = .validatesAlways
            $0.add(rule: RuleEmail())
            $0.add(rule: RuleRequired())
        }
        .cellSetup { cell, row in
            row.validate()
            cell.height = { 60 }
        }
        .onRowValidationChanged { _, _ in
            guard let button = self.enviarButton else {
                return
            }

            let errors = self.form.validate()
            button.actionButton.isEnabled = errors.isEmpty
        }
    }

    private func setButton() {
        enviarButton = ButtonFooter(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 120))
        enviarButton?.actionButton.setTitle(UserMessages.FinalizarColecta.buttonMessage, for: .normal)
        enviarButton?.actionButton.isEnabled = false
        enviarButton?.onAction = {
            self.enviarButtonPressed()
        }
        tableView?.tableFooterView = enviarButton
    }

    private func enviarButtonPressed() {
        let email = getEmail()
        guard let emailToSend = email else {
            return
        }

        let alert = UIAlertController(title: UserMessages.FinalizarColecta.alertTitle, message: UserMessages.FinalizarColecta.alertInfo.parametrize(emailToSend), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: UserMessages.FinalizarColecta.alertCancel, style: UIAlertActionStyle.default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: UserMessages.FinalizarColecta.alertSend, style: UIAlertActionStyle.default, handler: { action in
            self.endColecta(email: emailToSend)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    private func endColecta(email: String) {
        LoadingIndicator.show()
        DataManager.shared.closeRegalo(regaloId: regalo.id, email: email)
        .do( onError: { [weak self] (error) in
            LoadingIndicator.hide()
            if let error = error as? OperaError {
                self?.showOperaError(error: error)
            } else {
                self?.showError(UserMessages.networkError)
            }
        }, onCompleted: { [weak self] in
            LoadingIndicator.hide()
            self?.sendToConfirmacion(email: email)
        })
        .subscribe()
        .addDisposableTo(disposeBag)

    }

    private func showOperaError(error: OperaError) {
        switch error {
        case .networking(_, _, _, _):
            showError(UserMessages.FinalizarColecta.networkError)
        default:
            break
        }
        showError(UserMessages.networkError)
    }

    private func sendToConfirmacion(email: String) {
        let confirmacionViewController = R.storyboard.main.confirmacionEnvioViewController()
        confirmacionViewController?.email = email
        navigationController?.pushViewController(confirmacionViewController!, animated: true)
    }

    private func getEmail() -> String? {
        let formValues = form.values()
        return formValues[finalizarRowTags.emailTag] as? String
    }

}
