//
//  RegaloDetailViewController.swift
//  Iujuu
//
//  Created by user on 9/30/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit
import XLSwiftKit
import Eureka

class RegaloDetailViewController: FormViewController {

    var regalo: Regalo? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeader()
        setUpRows()
        setUpStyles()
    }

    private func setUpStyles() {
        view.backgroundColor = UIColor.ijWhiteColor()
        tableView?.backgroundColor = UIColor.ijWhiteColor()
        tableView?.backgroundView = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
        setUpParticiparButton()
    }

    private func setUpNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        title = "Colecta"
    }

    private func setUpParticiparButton() {
        let buttonFooter = ButtonFooter(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100))
        tableView?.tableFooterView = buttonFooter
        buttonFooter.actionButton.setTitle("Participar", for: .normal)
    }

    private func setUpHeader() {
        guard let regaloToShow = regalo else {
            return
        }
        let headerHeight = suggestedVerticalConstraint(340)
        let regaloHeader = R.nib.regaloDetailHeader.firstView(owner: nil)
        regaloHeader?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight)
        regaloHeader?.setup(regalo: regaloToShow)
        tableView?.tableHeaderView = regaloHeader
    }

    private func setUpRows() {
        form +++ Section()

        <<< LabelRow() {
            $0.title = "Ya participaron 8 personas"
        }
        .cellSetup { cell, _ in
            cell.textLabel?.font = UIFont.regular(size: 17)
            cell.height = { 60 }
        }
    }
}
