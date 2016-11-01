//
//  ConfirmationCodeViewController.swift
//  Iujuu
//
//  Created by Diego Ernst on 10/5/16.
//  Copyright © 2016 'Xmartlabs SRL'. All rights reserved.
//

import Foundation
import UIKit
import Ecno
import Crashlytics
import XLSwiftKit

class ConfirmationCodeViewController: XLTableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var balloonHeightConstraint: NSLayoutConstraint!

    var regalo: Regalo!

    var comingFromDeeplink: Bool {
        return navigationController == nil
    }

    override var prefersStatusBarHidden: Bool {
        return navigationController == nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        stylize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    private func stylize() {
        balloonHeightConstraint.constant = suggestedHorizontalConstraint(130)
        title = ""
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(R.nib.regaloCell(), forCellReuseIdentifier: R.reuseIdentifier.regaloCell.identifier)
        tableView.backgroundColor = .white

        titleLabel.font = .regular(size: 20)
        titleLabel.textColor = .ijGreyishBrownColor()
        titleLabel.text = UserMessages.ConfirmationCode.youWereInvited

        addButton.setStyle(.primary)
        addButton.setTitle(UserMessages.ConfirmationCode.addRegalo, for: .normal)
        cancelButton.setStyle(.borderless(titleColor: .ijGreyishBrownColor()))
        cancelButton.setTitle(UserMessages.ConfirmationCode.whyAmIHere, for: .normal)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: UserMessages.back, style: .done, target: self, action: #selector(backTapped))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onboardingViewController = segue.destination as? OnboardingViewController {
            onboardingViewController.mode = .fromDeepLink(withRegalo: regalo)
        }
    }

    func backTapped() {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func addButtonDidTouch(_ sender: UIButton) {
        addRegalo()
    }

    @IBAction func cancelButtonDidTouch(_ sender: UIButton) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            if DataManager.shared.getCurrentUser() != nil {
                UIApplication.changeRootViewController(R.storyboard.main().instantiateInitialViewController()!)
            } else {
                UIApplication.changeRootViewController(R.storyboard.onboarding.onboardingViewController()!)
            }
        }
    }

    private func addRegalo() {
        guard let regalo = regalo else { return }
        guard DataManager.shared.getCurrentUser() != nil else {
            AfterLoginPending.shared.add(pending: { DataManager.shared.joinToRegalo(regalo: regalo) })
            if Ecno.beenDone(Constants.Tasks.onboardingCompleted) {
                let welcomeViewController = R.storyboard.onboarding.welcomeViewController()!
                UIApplication.changeRootViewController(welcomeViewController)
            } else {
                performSegue(withIdentifier: R.segue.confirmationCodeViewController.showOnboarding, sender: nil)
            }
            return
        }

        LoadingIndicator.show()
        DataManager.shared
            .joinToRegalo(regalo: regalo)
            .do(
                onNext: { [weak self] _ in
                    LoadingIndicator.hide()
                    guard let me = self else { return }

                    if me.comingFromDeeplink {
                        let navigationController = UINavigationController()
                        let homeViewController = R.storyboard.main.homeViewController()!
                        let detailViewController = R.storyboard.main.regaloDetailViewController()!
                        detailViewController.regalo = regalo
                        let controllers = [homeViewController, detailViewController]
                        navigationController.setViewControllers(controllers, animated: false)
                        UIApplication.changeRootViewController(navigationController)
                    } else {
                        me.performSegue(withIdentifier: R.segue.confirmationCodeViewController.showHome, sender: nil)
                    }
                },
                onError: { [weak self] error in
                    LoadingIndicator.hide()
                    Crashlytics.sharedInstance().recordError(error)
                    let alt = (title: UserMessages.errorTitle, message: UserMessages.ParticiparRegalo.couldNotJoinError)
                    self?.showError(error, alternative: alt)
                }
            )
            .subscribe()
            .addDisposableTo(disposeBag)
    }

}

extension ConfirmationCodeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.regaloCell.identifier) as? RegaloCell ?? RegaloCell()
        cell.centerMotivo = true
        cell.setup(regalo: regalo)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return min(RegaloCell.rowHeight, tableView.bounds.height)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

}

extension UserMessages.ConfirmationCode {

    static let youWereInvited = NSLocalizedString("Fuiste invitado a un regalo!", comment: "")
    static let addRegalo = NSLocalizedString("Participar del regalo", comment: "")
    static let whyAmIHere = NSLocalizedString("Cancelar", comment: "")

}
