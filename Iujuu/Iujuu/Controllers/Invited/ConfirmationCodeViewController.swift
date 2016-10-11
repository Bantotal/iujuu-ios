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

class ConfirmationCodeViewController: XLTableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    var regalo: Regalo!

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
        } else if let regaloDetailController = segue.destination as? RegaloDetailViewController {
            // from insert code
            regaloDetailController.regalo = regalo
        } else if let regaloDetailController = (segue.destination as? UINavigationController)?.topViewController as? RegaloDetailViewController {
            // from deeplink
            regaloDetailController.regalo = regalo
        }
    }

    func backTapped() {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func addButtonDidTouch(_ sender: UIButton) {
        if Ecno.beenDone(Constants.Tasks.onboardingCompleted) {
            if let _ = navigationController {
                performSegue(withIdentifier: R.segue.confirmationCodeViewController.showRegaloDetail, sender: nil)
            } else {
                performSegue(withIdentifier: R.segue.confirmationCodeViewController.presentRegaloDetail, sender: nil)
            }
        } else {
            performSegue(withIdentifier: R.segue.confirmationCodeViewController.showOnboarding, sender: nil)
        }
    }

    @IBAction func cancelButtonDidTouch(_ sender: UIButton) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            if let _ = SessionController.sharedInstance.token, let _ = DataManager.shared.userId {
                UIApplication.changeRootViewController(R.storyboard.main().instantiateInitialViewController()!)
            } else {
                UIApplication.changeRootViewController(R.storyboard.onboarding.onboardingViewController()!)
            }
        }
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

    static let youWereInvited = NSLocalizedString("Fuiste invitado a una colecta!", comment: "")
    static let addRegalo = NSLocalizedString("Agregar colecta", comment: "")
    static let whyAmIHere = NSLocalizedString("Esta no es mi colecta", comment: "")

}
