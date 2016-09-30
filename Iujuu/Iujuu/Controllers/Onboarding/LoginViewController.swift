//
//  LoginViewController.swift
//  Iujuu
//
//  Created by user on 9/28/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit
import Eureka
import RxSwift
import Opera

struct loginRowTags {
    static let emailRow = "email row"
    static let passwordRow = "password row"
}

class LoginViewController: FormViewController {

    let disposeBag = DisposeBag()
    let validationChanged = Variable<Bool>(false)
    var buttonFooter: ButtonFooter?

    var _prefersStatusBarHidden = true
    override var prefersStatusBarHidden: Bool {
        return _prefersStatusBarHidden
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftNavigationCancel(withTarget: self, action: #selector(LoginViewController.cancel))
        setUpForm()
    }

    func cancel() {
        dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        _prefersStatusBarHidden = false
        setNeedsStatusBarAppearanceUpdate()

        setUpNavigationBar()
        setIngresarButton()

        validationChanged.asObservable()
        .do(onNext: { [weak self] changed in

            guard let me = self else { return }
            guard changed else { return }

            let errors = me.form.validate()
            if errors.isEmpty {
                me.buttonFooter?.actionButton.isEnabled = true
            } else {
                me.buttonFooter?.actionButton.isEnabled = false
            }
        })
        .subscribe()
        .addDisposableTo(disposeBag)
    }

    private func setIngresarButton() {
        buttonFooter = ButtonFooter(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100))
        tableView?.tableFooterView = buttonFooter
        buttonFooter?.actionButton.isEnabled = false
        buttonFooter?.actionButton.setTitle(UserMessages.LogIn.buttonText, for: .normal)
        buttonFooter?.onAction = {
            self.loginUser()
        }
    }

    private func setUpNavigationBar() {
        navigationController?.navigationBar.topItem?.title = UserMessages.LogIn.title
    }

    private func loginUser() {
        let userToLogIn = getUserToLogIn()
        LoadingIndicator.show()
        DataManager.shared.login(username: nil, email: userToLogIn.email, password: userToLogIn.password)?
        .do( onError: { [weak self] (error) in
            LoadingIndicator.hide()
            if let error = error as? OperaError {
                self?.showOperaError(error: error)
            } else {
                self?.showError(UserMessages.networkError)
            }
        },
        onCompleted: {
            LoadingIndicator.hide()
            UIApplication.changeRootViewController(R.storyboard.main().instantiateInitialViewController()!)
        })
        .subscribe()
        .addDisposableTo(disposeBag)
    }

    private func showOperaError(error: OperaError) {
        switch error {
        case let .networking(_, _, response, _):
            if response?.statusCode == Constants.Network.Unauthorized {
                showError(UserMessages.Register.loginError)
            }
        default:
            showError(UserMessages.networkError)
            break
        }
    }

    private func getUserToLogIn() -> (email: String, password: String) {
        let formValues = form.values()

        let email = formValues[loginRowTags.emailRow] as? String
        let password = formValues[loginRowTags.passwordRow] as? String

        return (email: email!, password: password!)
    }

    private func setUpForm() {

        form +++ Section()

            <<< EmailRow(loginRowTags.emailRow) {
                $0.title = UserMessages.email
                $0.placeholder = nil
                $0.keyboardReturnType = KeyboardReturnTypeConfiguration(nextKeyboardType: .continue, defaultKeyboardType: .done)

                $0.validationOptions = .validatesAlways
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            .onRowValidationChanged { [weak self] cell, row in
                self?.validationChanged.value = true
            }

            <<< PasswordRow(loginRowTags.passwordRow) {
                $0.title = UserMessages.password
                $0.placeholder = nil
                $0.keyboardReturnType = KeyboardReturnTypeConfiguration(nextKeyboardType: .continue, defaultKeyboardType: .done)
                $0.validationOptions = .validatesAlways
                $0.add(rule: RuleRequired())
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            .onRowValidationChanged { [weak self] cell, row in
                self?.validationChanged.value = true
            }

    }

}
