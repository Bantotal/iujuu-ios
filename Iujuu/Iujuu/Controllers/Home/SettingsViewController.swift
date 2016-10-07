//
//  SettingsViewController.swift
//  Iujuu
//
//  Created by user on 9/29/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import UIKit
import Eureka
import Opera
import RxSwift

class SettingsViewController: FormViewController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpRows()
        addLogoutbutton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    private func setUpNavigationBar() {
        title = UserMessages.Settings.title
    }

    private func setUpRows() {
        form +++ Section (UserMessages.Settings.headerTitle)

            <<< ButtonRow() {
                $0.title = DataManager.shared.getUser()?.nombre
            }
            .cellUpdate { cell, _ in
                cell.accessoryType = .none
                cell.editingAccessoryType = cell.accessoryType
            }

        form +++ Section()

            <<< ButtonRow () {
                $0.title = UserMessages.Settings.aboutRow
            }
            .onCellSelection { _, _ in
                let webViewController = WebViewController()
                webViewController.pageTitle = "About"
                self.navigationController?.pushViewController(webViewController, animated: true)
            }

            <<< ButtonRow () {
                $0.title = UserMessages.Settings.faqRow
            }
            .onCellSelection { _, _ in
                let webViewController = WebViewController()
                webViewController.pageTitle = "FAQ"
                self.navigationController?.pushViewController(webViewController, animated: true)
            }

            <<< ButtonRow () {
                $0.title = UserMessages.Settings.legalRow
            }
            .onCellSelection { _, _ in
                let webViewController = WebViewController()
                webViewController.pageTitle = "Legal"
                self.navigationController?.pushViewController(webViewController, animated: true)
            }
    }

    private func addLogoutbutton() {
        let button = LogoutButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 60))
        button.onAction = {
            self.logout()
        }
        tableView?.setFooterAtBottom(button, tableHeight: UIScreen.main.bounds.height - 120)
    }

    private func logout() {
        LoadingIndicator.show()
        DataManager.shared.logout()?
        .do(onError: { [weak self] error in
            LoadingIndicator.hide()
            self?.showError(UserMessages.errorTitle, message: UserMessages.Settings.logoutError)
        }, onCompleted: {
            LoadingIndicator.hide()
            UIApplication.changeRootViewController(R.storyboard.onboarding().instantiateInitialViewController()!)
        })
        .subscribe()
        .addDisposableTo(disposeBag)
    }
}
