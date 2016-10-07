//
//  ParticiparViewController.swift
//  Iujuu
//
//  Created by user on 10/4/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit
import Eureka
import RxSwift
import XLSwiftKit

private struct participarRowTags {
    static let messageTag = "message row"
    static let importeTag = "importe row"
    static let imageTag = "image row"
}

class ParticiparViewController: FormViewController {

    var regalo: Regalo? = nil
    let disposeBag = DisposeBag()
    var buttonFooter: ButtonFooter?
    
    //MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeader()
        setUpRows()
        setUpStyles()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        setUpConfirmarButton()
    }

    //MARK: - Styles setup

    private func setUpStyles() {
        view.backgroundColor = UIColor.ijWhiteColor()
        tableView?.backgroundColor = UIColor.ijWhiteColor()
        tableView?.backgroundView = nil
    }

    private func setUpNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        title = UserMessages.ParticiparRegalo.title
    }
    
    //MARK: - Table setup

    private func setUpHeader() {
        guard let regaloToShow = regalo else {
            return
        }
        let headerHeight = suggestedVerticalConstraint(180)
        let regaloHeader = R.nib.regaloDetailHeader.firstView(owner: nil)
        regaloHeader?.showImage = false
        regaloHeader?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight)
        regaloHeader?.setup(regalo: regaloToShow)
        tableView?.tableHeaderView = regaloHeader
    }

    private func setUpRows() {
        
        form +++ Section()

        <<< TextAreaRow(participarRowTags.messageTag) {
            $0.placeholder = UserMessages.ParticiparRegalo.messagePlaceholder
        }
        .cellSetup { cell, row in
            cell.placeholderLabel.font = UIFont.regular(size: 15)
            cell.textView.font = .regular(size: 18)
            cell.textView.textColor = UIColor.ijWarmGreyColor()
        }

        <<< ImageRow(participarRowTags.imageTag) {
            $0.title = UserMessages.ParticiparRegalo.imageMessage
        }
        .cellSetup { cell, _ in
            cell.textLabel?.font = UIFont.regular(size: 15)
            cell.height = { 60 }
            let image = R.image.cameraIcon()
            cell.imageView?.image = image
            cell.imageView?.contentMode = .center
            cell.accessoryType = .none
        }

        <<< FloatingLabelRow(participarRowTags.importeTag) {
            $0.validationOptions = .validatesAlways
            $0.add(rule: RuleIntRequired())
        }
        .cellSetup { cell, row in
            row.validate()
            cell.height = { 120 }
        }
        .onRowValidationChanged { _, _ in
            guard let button = self.buttonFooter else {
                return
            }

            let errors = self.form.validate()
            if errors.isEmpty {
                button.actionButton.isEnabled = true
            } else {
                button.actionButton.isEnabled = false
            }
        }


        <<< LabelRow() {
            $0.title = UserMessages.ParticiparRegalo.galiciaMessage
        }
        .cellSetup { cell, _ in
            cell.textLabel?.font = UIFont.regular(size: 16)
            cell.textLabel?.numberOfLines = 0
        }

    }
    
    private func setUpConfirmarButton() {
        buttonFooter = ButtonFooter(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100))
        tableView?.tableFooterView = buttonFooter
        buttonFooter?.actionButton.isEnabled = false
        buttonFooter?.onAction = {
            self.pagarConGaliciaPressed()
        }
        buttonFooter?.actionButton.setTitle(UserMessages.ParticiparRegalo.buttonMessage, for: .normal)
    }

    //MARK: - Actions

    private func pagarConGaliciaPressed() {
        //TODO - send to pagar con galicia
    }

    private func getFormData() -> [String : Any] {
        let formValues = form.values()

        let importe = formValues[participarRowTags.importeTag] as? Int
        var values: [String : Any] = ["importe": String(importe!)]

        if let message = formValues[participarRowTags.messageTag] as? String {
            values["message"] = message
        }

        if let image = formValues[participarRowTags.imageTag] as? UIImage {
            values["imagen"] = image
        }

        return values
    }

}
