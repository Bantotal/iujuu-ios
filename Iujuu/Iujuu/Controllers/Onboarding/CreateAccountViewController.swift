//
//  CreateAccountViewController.swift
//  Iujuu
//
//  Created by Diego Ernst on 9/22/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import RxSwift

struct rowTags {
    static let firstNameRow = "first name"
    static let lastNameRow = "last name"
    static let emailRow = "email row"
    static let passwordRow = "password row"
}

class CreateAccountViewController: FormViewController {

    let disposeBag = DisposeBag()
    let validationChanged = Variable<Bool>(false)
    var buttonFooter: ButtonFooter?

    var _prefersStatusBarHidden = true
    override var prefersStatusBarHidden: Bool {
        return _prefersStatusBarHidden
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftNavigationCancel(withTarget: self, action: #selector(Progress.cancel))
        setupForm()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _prefersStatusBarHidden = false
        setNeedsStatusBarAppearanceUpdate()
        buttonFooter = ButtonFooter(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100))
        tableView?.setFooterAtBottom(buttonFooter!, tableHeight: view.bounds.height - (28 * 2))
        buttonFooter?.actionButton.isEnabled = false
        buttonFooter?.onAction = {
            self.registerUser()
        }

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

    func registerUser() {
        let createdUser = getUserFromForm()
        DataManager.shared.registerUser(user: createdUser.user, password: createdUser.password)?
        .do(onNext: { user in
            //TODO - save to db as current user
        }
        ,onError: { error in
            self.showError(UserMessages.Register.errorTitle, message: UserMessages.Register.registerError)
        }
        ,onCompleted: {
            UIApplication.changeRootViewController(R.storyboard.createRegalo().instantiateInitialViewController()!)
        })
        .subscribe()
        .addDisposableTo(disposeBag)
    }

    private func getUserFromForm() -> (user: User, password: String)  {
        let formValues = form.values()

        let firstName = formValues[rowTags.firstNameRow] as! String
        let lastName = formValues[rowTags.lastNameRow] as! String
        let email = formValues[rowTags.emailRow] as! String
        let password = formValues[rowTags.passwordRow] as! String

        let newUser = User()
        newUser.nombre = firstName
        newUser.apellido = lastName
        newUser.email = email

        return (user: newUser, password: password)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func cancel() {
        dismiss(animated: true, completion: nil)
    }

    private func setupForm() {
        let form = Form()
        form +++ Section()

            <<< NameRow(rowTags.firstNameRow) {
                $0.title = UserMessages.firstName
                $0.keyboardReturnType = KeyboardReturnTypeConfiguration(nextKeyboardType: .continue, defaultKeyboardType: .done)
                $0.validationOptions = .validatesOnChangeAfterBlurred
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

            <<< NameRow(rowTags.lastNameRow) {
                $0.title = UserMessages.lastname
                $0.keyboardReturnType = KeyboardReturnTypeConfiguration(nextKeyboardType: .continue, defaultKeyboardType: .done)
                $0.validationOptions = .validatesOnChangeAfterBlurred
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

            <<< EmailRow(rowTags.emailRow) {
                $0.placeholder = nil
                $0.keyboardReturnType = KeyboardReturnTypeConfiguration(nextKeyboardType: .continue, defaultKeyboardType: .done)
                $0.validationOptions = .validatesOnChangeAfterBlurred
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

            <<< GenericPasswordRow(rowTags.passwordRow) {
                $0.add(rule: RuleRequired())
                $0.add(rule: RulePasswordIsValid())
                $0.validationOptions = .validatesAlways
            }
            .onRowValidationChanged { [weak self] cell, row in
                self?.validationChanged.value = true
            }

        self.form = form
    }

}
